Lets talk it out.
 * [I had no choice.] -> denial
 * [I made the best choices I had.] -> accept

- ...

 * (denial) ->
    - > You say you had no choice. Maud is unconvinced
    - MAUD: Everything you have done and have yet to do here has already happened.
    - MAUD: You are a merely an afterimage of the gray loop. As am I. 
    - MAUD: Despite this, I can confidently state even THIS instance of you has had decisions plenty, no matter how trivial you perceived them to be.
    - MAUD: ...
    - MAUD: Perhaps it will comfort you to know that this meeting was not one of your choices.
        * [...] -> speechend

 * (accept) ->
    - > You say you had made the best choices you could think of. 
    - MAUD: Ha, is that so?
    - MAUD: Very well, that is good you are content.
    - MAUD: Not that it matters in the grand tapestry of this infinite dimension.
    - MAUD: You are an image reconstructed by the gray loop, projected onto a quantum fog.
    - MAUD: ...
    - MAUD: Tracking infinite branching potentials is beyond even my own powers. I know not truly which apparition you are or what you have done. 
    - MAUD: But if you intend to pass this gate, this choice will be your last here.
    * [...] -> speechend

 * (speechend) ->
    - MAUD: No matter what path you take in this realm
    - MAUD: You were destined to meet me, here.
    - MAUD: This was MY choice.
    - > Begin Fight?
    
    * [I'm not ready.] -> speechnotready
    * [It's on.] -> speechready
     
 * (speechnotready) ->
    - > I'm not ready.
    - MAUD: Fascinating. Truthfully, I was hoping for the opportunity to observe you further. So I will allow it. You will hear my words again when you return.
    -> END
    
 * (speechready) ->
    - We shall begin your final challenge then.
    -> END


