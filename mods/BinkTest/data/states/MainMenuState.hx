import funkin.backend.MusicBeatState;
import funkin.backend.utils.NdllUtil;

function create(){

}


function postCreate()
{
    var doStuff = NdllUtil.getFunction("bink", "doStuff", 0);
    
    doStuff();
}
/**
 * TODO:
 * add language selector
 * add title screen
 */


