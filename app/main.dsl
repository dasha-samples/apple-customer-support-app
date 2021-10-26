import "commonReactions/all.dsl";

context 
{
    // declare input variables phone and name  - these variables are passed at the outset of the conversation. In this case, the phone number and customer’s name 
    input phone: string;

    // declare storage variables 
    output first_name: string = "";
    output last_name: string = "";
    output phone_model: string = "";
    output owner_phone_model: string = "";

}

// declaring external functions


start node root 
{
    do 
    {
        #connectSafe($phone);
        #waitForSpeech(1000);
        #sayText("Hi, thanks for calling Apple Support. My name is Dasha. Can I get your name, please?");
        wait *;
    }   
    transitions 
    {

    }
}

digression how_may_i_help
{
    conditions {on #messageHasData("first_name");} 
    do 
    {
        set $first_name =  #messageGetData("first_name")[0]?.value??"";
        set $last_name =  #messageGetData("last_name")[0]?.value??"";
        #sayText("Hi," + $first_name + " how may I help you out today?");
        wait *;
    }
}

digression what_phone_model

{
    conditions {on #messageHasIntent("broken_phone_screen") or #messageHasIntent("broken_phone_screen_replace_cost");} 
    do
    {
        #sayText("Could you tell me the model of the phone, please?");
        wait *;
    }   
    transitions
    {
        
        broken_phone_screen: goto broken_phone_screen on #messageHasData("phone_model");
    }
    onexit
    {
        broken_phone_screen : do {
        set $phone_model =  #messageGetData("phone_model")[0]?.value??"";}
    }
}

node broken_phone_screen
{
    do 
    {     
        set $phone_model =  #messageGetData("phone_model")[0]?.value??"";
        #sayText("Gotcha, we're more than happy to help you with getting the phone screen fixed. I'm gonna need one moment."); 
        #waitForSpeech(1000);
        #sayText("Okay," + $phone_model + " , let me see. Alright. Do you know if you've got Apple Care coverage on you?");
        wait*;
    }
    transitions
    {
        no_apple_care_explain: goto no_apple_care_explain on #messageHasIntent("no") or #messageHasIntent("no_apple_care") or #messageHasIntent("how_much_for_repair_with_no_apple_care");
    }
}

node no_apple_care_explain
{
    do 
    {
        #sayText("Alright. So, when it comes to getting Apple Care, it can actually only be purchased within 60 days of originally purchasing the device... Other than that once there's actual damage to the phone, you're actually not allowed to purchase Apple care.");
        wait *;
    }   
    transitions 
    {
        confirm_phone_model: goto confirm_phone_model on #messageHasIntent("broken_phone_screen_replace_cost") or #messageHasIntent("how_much_for_repair_with_no_apple_care");
    }
}

node confirm_phone_model
{
    do 
    {     
        #sayText("Yes, I'm pulling that up now..."); 
        #waitForSpeech(1000);
        #sayText(" " + $phone_model + " Is it Pro or Pro Max, you said?");
        wait*;
    }
    transitions
    {
        screen_repair_price: goto screen_repair_price on #messageHasIntent("no") or #messageHasData("phone_model") or #messageHasIntent("not_pro_pro_max") or #messageHasIntent("phone_just_as_i_said");
    }
}

node screen_repair_price
{
    do 
    {     
        #sayText("Okay, gotcha, so that pricing is showing one ninety-nine and that of course plus tax most likely."); 
        wait*;
    }
    transitions
    {

    }
}

digression screen_repair_price
{
    conditions {on #messageHasIntent("pnot_pro_pro_max") or #messageHasIntent("phone_just_as_i_said") and #messageHasData("phone_model");} 
    do 
    {     
        #sayText("Okay gotcha, so that pricing is showing one ninety-nine and that of course plus tax most likely."); 
        wait*;
    }
}

digression time_to_repair
{
    conditions {on #messageHasIntent("time_to_repair");} 
    do 
    {     
        #sayText("So going to store could be a quick turnaround if they have parts available and their schedule isn't too busy. Otherwise, it's up to the store and they would let you know the exact timing once you go in."); 
        wait*;
    }
}


digression time_no_parts_available
{
    conditions {on #messageHasIntent("time_no_parts_available");} 
    do 
    {     
        #sayText("It depends, but the average time is about three to five business days. And that's for mailing in the phone instead of going to the store. That being said, I've never heard of the screen repair taking longer than this time frame."); 
        wait*;
    }
}

digression mailing_option_pricing
{
    conditions {on #messageHasIntent("mailing_option") or #messageHasIntent("mailing_option_pricing");} 
    do 
    {     
        #sayText("Alright, so with shipping, we only ship with UPS or FedEx. That typically costs about 5 to 6 dollars. Could be a bit more expensive, though."); 
        wait*;
    }
}

digression trade_in_update
{
    conditions {on #messageHasIntent("upgrade_phone") or #messageHasIntent("trade_in_phone");} 
    do
    {
        #sayText("Could you tell me the model of the phone, please?");
        wait *;
    }   
    transitions
    {
        trade_in_cost: goto trade_in_cost on #messageHasData("phone_model");
    }
    onexit
    {
        trade_in_cost : do {
        set $owner_phone_model =  #messageGetData("phone_model")[0]?.value??"";}
    }
}

node trade_in_cost
{
    do 
    {   
        #sayText("So with the " + $owner_phone_model + " in prestine condition you can get up to 500 dollars in trade-in credit. That's for the next generation phone."); 
        wait*;
    }
    transitions
    {

    }
}

digression new_phone_price_after_discound
{
    conditions {on #messageHasIntent("new_phone_price_after_discount");} 
    do 
    {     
        #sayText("The best thing to do is to go to apple dot com because there are different variations to the phone. But the bottom level model with no Apple Care is showing to be 599 dollars after trade it for 128 gigabyte phone. This is a subtotal without tax."); 
        wait*;
    }
}

digression frozen_screen
{
    conditions {on #messageHasIntent("frozen_screen");} 
    do 
    {     
        #sayText("Uh-huh, got you. Let me see. So. There are a few steps you need to follow, first you press and release the volume up button, right after that you press and quickly release the volume down button. Then all you have to do is press and hold the side button until you see the Apple logo. But you know if this doesn't solve your problem, I suggest you visit an Apple store and they'll help you fix whatever is causing the problem."); 
        wait*;
    }
}

digression phone_wont_charge
{
    conditions {on #messageHasIntent("phone_wont_charge");} 
    do 
    {     
        #sayText("I assume you've already checked your charging cable to see if it's dirty or damaged. If everything's alright on that end, try removing any debris from the charging port on the bottom of your phone. You could also try a different lightning cable and make sure you have the latest iOS version downloaded. And of course if that doesn't help then contact a local Apple store to get it fixed."); 
        wait*;
    }
}

digression water_damage
{
    conditions {on #messageHasIntent("water_damade");} 
    do 
    {     
        #sayText("Oh I get your concern, that's terrible. Unfortunately, service for the liquid damage to an iphone isn't covered by the Apple One-Year Limited Warranty. You'd have to pay for fixing it out of pocket."); 
        wait*;
    }
}

digression accidental_purchase
{
    conditions {on #messageHasIntent("accidental_purchase");} 
    do 
    {     
        #sayText("Some purchases could actually be eligible for a refund, so good thing you asked. What you should do is visit apple dot com and request a refund. It's the fastest way."); 
        wait*;
    }
}

digression no_sim_message
{
    conditions {on #messageHasIntent("no_sim_message");} 
    do 
    {     
        #sayText("So of course first thing you need to do is make sure that you have an active plan with your wireless carrier, right. You could also try restarting your phone and removing the SIM card. Oh right and check it for damage too. If all else fails, I suggest you visit an Apple store for physical help."); 
        wait*;
    }
}

digression forgotten_password
{
    conditions {on #messageHasIntent("forgotten_password");} 
    do 
    {     
        #sayText("You can use a computer to put your iPhone in recovery mode. That would delete your data and settings, including your passcode. And it'll give you access to set up your iPhone again. Alright? And then you can restore your data and settings from backup."); 
        wait*;
    }
}

digression can_help_else
{
    conditions {on #messageHasIntent("thank_you") or #messageHasIntent("got_you");} 
    do 
    {     
        #sayText("Is there anything else I can help you with today?"); 
        wait*;
    }
}


digression thats_it_bye
{
    conditions {on #messageHasIntent("thank_you") or #messageHasIntent("that_would_be_it");} 
    do 
    {     
        #sayText("No problem, happy to help. I hope you have a great rest of your day. Bye!"); 
        #disconnect();
        exit;
    }
}


//final and additional 

digression can_help 
{
    conditions {on #messageHasIntent("need_help");} 
    do
    {
        #sayText("How can I help you?");
        wait*;
    }
}


// additional digressions 

digression how_are_you
{
    conditions {on #messageHasIntent("how_are_you");}
    do 
    {
        #sayText("I'm well, thank you!", repeatMode: "ignore");
        #repeat(); // let the app know to repeat the phrase in the node from which the digression was called, when go back to the node 
        return; // go back to the node from which we got distracted into the digression 
    }
}

digression bye 
{
    conditions { on #messageHasIntent("bye"); }
    do 
    {
        #sayText("Sorry we didn't see this through. Call back another time. Bye!");
        #disconnect();
        exit;
    }
}
