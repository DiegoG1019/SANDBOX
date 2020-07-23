using System;
using System.CodeDom;
using System.Collections.Generic;
using System.IO;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;

namespace ConsoleApp1
{
	public static class KeyManager
	{
		public sealed class Lock<TQuery, TValue> where TQuery : new() where TValue : new() //This is mostly unnecessary, but might prove useful in the future. And I kinda wanted to test out the idea.
		{
			private readonly List<Key> validkeys = new List<Key>();

			private Dictionary<TQuery, TValue> Data { get; set; }
			public Dictionary<TQuery, TValue> LockedData
            {
                get
                {

					_ValidateArmed();
					return Data;
                }
                set
                {
					_ValidateArmed();
					Data = value;
                }
            }

			/// <summary>
			/// WARNING: Can lead to unexpected behaviour.
			/// </summary>
			public Dictionary<TQuery, TValue> SafeAccessLockedData
            {
                get
                {
                    try
                    {
						return LockedData;
                    }
                    catch (InvalidOperationException)
                    {
						return null;
                    }
                }
                set
                {
                    try
                    {
						LockedData = value;
                    }
                    catch (InvalidOperationException)
                    {
						return;
                    }
                }
            }

			public bool IsArmed { get; private set; }

			public Lock(params Key[] keys) :
				this(false, keys)
			{ }
			public Lock(bool isArmed, params Key[] keys)
			{
				IsArmed = isArmed;
				validkeys = new List<Key>(keys);
			}

			//Make sure to set this to false, this is a debug option and compromises integrity of security.
			const bool verboseexceptions = true;

			private void _ValidateArmed()
			{
				if (!IsArmed)
				{
					return;
				}
				throw new InvalidOperationException("This Lock has to be accessed with a Key");
			}
			private void _ValidateKey(Key key)
			{
				if (!IsArmed || validkeys.Contains(key))
				{
					return;
				}
				if (verboseexceptions)
				{
					string s = string.Empty;
					foreach (Key k in validkeys)
					{
						s += $"{k.Value} | ";
					}
					throw new InvalidOperationException($"This Lock has to be accessed with a Key. Used Key: {key}. Valid keys: {s}");
				}
				throw new InvalidOperationException("Invalid Key for this Lock");
			}

			public void ReplaceDataObject(Dictionary<TQuery, TValue> data)
            {
				Data = data;
            }

			public TValue GetSafeData(TQuery query)
			{
				_ValidateArmed();
				return Data[query];
			}
			public TValue GetSafeData(Key key, TQuery query)
			{
				_ValidateKey(key);
				return Data[query];
			}

			public void SetSafeData(TQuery query, TValue value)
			{
				_ValidateArmed();
				Data[query] = value;
			}
			public void SetSafeData(Key key, TQuery query, TValue value)
			{
				_ValidateKey(key);
				Data[query] = value;
			}

			public TValue TryGetSafeData(TQuery query)
			{
				try
				{
					return GetSafeData(query);
				}
				catch (InvalidOperationException)
				{
					return new TValue();
				}
			}
			public TValue TryGetSafeData(Key key, TQuery query)
			{
				try
				{
					return GetSafeData(key, query);
				}
				catch (InvalidOperationException)
				{
					return new TValue();
				}
			}

			public void AddKey(Key AccessKey, Key newKey)
            {
				_ValidateKey(AccessKey);
				validkeys.Add(newKey);
            }

			public void RemoveKey(Key AccessKey, Key obsoleteKey)
            {
				_ValidateKey(AccessKey);
				validkeys.Remove(obsoleteKey);
            }

			public bool TryKey(Key key)
            {
                try
                {
					_ValidateKey(key);
                }
                catch(InvalidOperationException)
                {
					return false;
				}
				return true;
			}

			public void Arm(Key key)
			{
				if (validkeys.Contains(key))
				{
					IsArmed = true;
				}
			}

			public void Disarm(Key key)
			{
				if (validkeys.Contains(key))
				{
					IsArmed = false;
				}
			}
		}

		public sealed class Key //This allows complete control over the class and simplifies addition or removal of features. Basically, it simplifies maintenance. Since changes here will reflect everywhere.
		{
			public string Value { get; private set; }
			public const int KeyLength = 16;

			public Key(string k)
			{
				if (k.Length == KeyLength)
				{
					Value = k;
					return;
				}
				throw new InvalidDataException($"Invalid Key. Expected Length: {KeyLength}; Argument's Length: {k.Length}");
			}

			public static implicit operator string(Key k)
			{
				return k.Value;
			}

			public static bool operator ==(Key a, Key b)
			{
				return a.Value == b.Value;
			}

			public static bool operator !=(Key a, Key b)
			{
				return !(a == b);
			}

			public override bool Equals(object obj)
			{
				return base.Equals(obj);
			}

			public override int GetHashCode()
			{
				return base.GetHashCode();
			}

			public override string ToString()
			{
				return Value;
			}

		}

		public static List<Key> ActiveKeys { get; private set; }
		public static FixedSizeQueue<Key> UsedKeys { get; private set; }

		private static readonly Random _rand = new Random();

		private static Key GenKey()
		{
			var buffer = new byte[Key.KeyLength];
			_rand.NextBytes(buffer);
			return new Key(Encoding.UTF7.GetString(buffer));
		}

		public static Key IssueNewKey()
		{
			Attempt:;
			//I'd recommend some logging tool here. make a counter that counts the number of attempts and print out each time you fail one. I'd recommend Serilog // Log.Verbose
			var nid = GenKey();
			if (ActiveKeys.Contains(nid) || UsedKeys.Contains(nid))
			{
				goto Attempt;
			}
			ActiveKeys.Add(nid);
			return nid;
		}

		public static void DiscontinueKey(Key k)
		{
			if (ActiveKeys.Contains(k))
			{
				ActiveKeys.Remove(k);
				UsedKeys.Enqueue(k);
				return;
			}
			throw new InvalidOperationException("Cannot discontinue non-existent key");
		}

		static KeyManager()
		{
			ActiveKeys = new List<Key>();
			UsedKeys = new FixedSizeQueue<Key>(100);
		}

	}

	public class FixedSizeQueue<T> : Queue<T>
	{ //Automatically pushes out objects when full
		public int Limit { get; set; }
		public void Enqueue()
		{
			while (Count > Limit)
			{
				Dequeue();
			}
		}
		public FixedSizeQueue(int limit) : base(limit)
		{ //Queue(int capacity) //The initial number of objects Queue can contain
			Limit = limit;
		}
	}
}