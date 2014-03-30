package util 
{
	/**
	 * A collection of convenience functions and sugar used in ButtLords 64.
	 * @author Eric Dand
	 */
	public class EricsUtils 
	{
		/**
		 * Pick and return one of the arguments at random.
		 * @param	... args
		 * @return
		 */
        public static function oneOf(... args):Object {
            return args[(uint)(args.length * Math.random())];
        }
		
	}

}