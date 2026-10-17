import funkin.backend.MusicBeatState;
import funkin.backend.utils.NdllUtil;

function create(){

}


function postCreate()
{
    
    var doStuff = NdllUtil.getFunction("test", "sum", 2);
    
    trace(doStuff(1,2));
}
/**
 * TODO:
 * add language selector
 * add title screen
 */


