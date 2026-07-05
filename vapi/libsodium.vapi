[CCode (cheader_filename = "sodium.h")]
namespace Sodium {
	[CCode (cname = "sodium_init")]
	public int init ();	
	namespace Crypto {
		[CCode (cname = "crypto_pwhash_STRBYTES")]
		const int STRBYTES; // Length of the output string for password hashing
		namespace PwHash {
			[CCode (cname = "crypto_pwhash_str")]
			public int str(out uint8 hashed_buffer[Crypto.STRBYTES],  string password, size_t len, size_t opslimit, size_t memlimit);


			[CCode (cname = "crypto_pwhash_str_verify")]
			public int str_verify(string hashed_password, string password, size_t len);
		}

		[CCode (cprefix = "crypto_pwhash_")]
		public enum OpsLimit {
			INTERACTIVE
		}

		[CCode (cprefix = "crypto_pwhash_")]
		public enum MemLimit {
			INTERACTIVE
		}
	}
}
