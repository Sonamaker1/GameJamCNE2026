package;


import lime.system.CFFI;
import lime.system.JNI;


class SampleExtension {
	
	
	public static function sampleMethod (inputValue:Int):Int {
		
		#if android
		
		var resultJNI = sampleextension_sample_method_jni(inputValue);
		var resultNative = sampleextension_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative;
		
		#else
		
		return sampleextension_sample_method(inputValue);
		
		#end
		
	}
	
	
	private static var sampleextension_sample_method = CFFI.load ("sampleextension", "sampleextension_sample_method", 1);
	
	#if android
	private static var sampleextension_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.SampleExtension", "sampleMethod", "(I)I");
	#end
	
	
}