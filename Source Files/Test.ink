> Between you and the dimensional rift, the MAU sits before you.
> Beyond the gate lies your home -- or whatever is left of it.
> Impossibly, it feels like you have stood exactly here once before.
> A barrier emits a dull roar like a constant storm... and yet a voice pierces the wall of sound
> ... I guess it's time to talk it out
> The mechanism, MAU, utters coldly as ever to you: "Was it all worth it to get here?"
 * [I had no choice.] -> denial
 * [I made the best choices I had.] -> didbest
 * [I dunno what I'm doing] -> IDK
 * [I'll do what I must.] -> resolute
 * (denial) ->
    - > You say you had no choice. The MAU is unconvinced 
    - MAU: I do not blame you for feeling that way.
    - MAU: Everything you have done and have yet to do here has already happened 
    - MAU: You are a merely an afterimage of the gray storm after all. A ghost of an original. A copy replicated ad nauseum. A shadow made by lightning. And so am I. 
    * [\[listen\]] -> parttwo
 * (IDK) ->
    - > You say you don't know what is happening or what you are doing. 
    - > MAU's mechanical face crinkles, seemingly insulted.
    - MAU: Am I in the company of a fool? Or is this an act? 
    - MAU: In the versions I have met, your individual autonomy is usually your defining trait. It is a shame to see you deny it.
    * [\[listen.\]] -> parttwo
 * (parttwo) ->
    - MAU: Despite this, I can confidently state even THIS instance of you has had decisions plenty
    - MAU: No matter how trivial or compulsory you perceived them to be.
    - MAU: Perhaps it will comfort you to know that this meeting was not one of your choices.
        * [\[Listen.\]] -> speechend0
 * (didbest) ->
    - > You say you had made the best choices you could think of.
    - MAU: Ha, is that so?
    - MAU: Very well, that is good you are content. ->accept
 * (resolute) ->
    - > You say you you'll do what you must to pass.
    - MAU: How resolute. We will see if your confidence wavers. ->accept
 * (accept) ->
    - MAU: Not that it matters in the grand tapestry of this infinite dimension. 
    - MAU: You are only an image reconstructed by the gray storm, projected onto a quantum fog.
    - MAU: And you can be banished from existence just like the versions I met before you.
    * [...] -> speechend0
 * (speechend0) ->    
    - MAU: To that end, I know not truly which apparition you are or what you have done. 
    - MAU: Tracking infinite branching potentials is beyond even my own powers. 
    - MAU: Maybe all of you made the same choices, maybe you are at war with yourself
    - MAU: Or maybe curiousity got the better of you. 
    - MAU: But if you intend to pass this gate, this choice will be your last here.
    * [\[LISTEN.\]] -> speechend1
 * (speechend1) ->
    - MAU: No matter what path you take in this realm
    - MAU: You were destined to meet me, here.
    - MAU: This was MY choice.
    - > Begin Fight?
    * [I'm not ready.] -> speechnotready
    * [It's on, Let's Battle.] -> speechready
 * (speechnotready) ->
    - > I'm not ready.
    - MAU: Fascinating. Truthfully, I was hoping for the opportunity to observe you further. 
    - MAU: So I will allow it. You will hear my words again when you return. Or if you return.
    - MAU: I enjoy our talks. Perhaps next time you will remember enough to speak back.
    -> END
 * (speechready) ->
    - > You tell MAU you will fight it. 
    - > After all, how could you turn back now?
    - MAU: We shall begin your final challenge then.
    -> END


