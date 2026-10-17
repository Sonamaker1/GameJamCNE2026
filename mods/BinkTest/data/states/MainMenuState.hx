import funkin.backend.MusicBeatState;
import funkin.backend.utils.NdllUtil;

function create(){

}


function postCreate()
{
    
    var doStuff = NdllUtil.getFunction("test", "sum", 2);
    var getTeapotIfNumber = NdllUtil.getFunction("test", "teapot", 1);

    trace(doStuff(1,2));

    
    trace(getTeapotIfNumber(1));
    trace(getTeapotIfNumber("a"));
}
/**
 * TODO:
 * add language selector
 * add title screen
 */


