#!/usr/bin/env fish

set groups harvardwatch hciu goldmansachs sfbay chamber obamaadmin buffalo bubblebarons socialsecurity uk-revolvingdoor uk-education superpacs cuomowatch mapthefed nyseconomy frackerwatch ubwatch occupy theartworld nycpublicspace uva-watch puertorico shadowgovdefense shadowgoveducation uowatch shadowgovfinance templewatch connscuwatch usowatch whorulesgmu kentstatewatch osuwatch wrightstatewatch akronwatch cunywatch ucwatch pbwatch whorulesmacalester kochu takebackchicago NYC_Power_Analysis Power_Behind_The_Police RooseveltInstitute Election2016 pghpowermapping TrackingPES SURJ_Rural_Research PrisonWatch thepublicmemory ColoradoPowerResearch upr2017 DC_Research_Collective phillypower pennrose

for group in $groups
    set --local group_url "https://littlesis.org/groups/$group"
    wget --page-requisites $group_url
    sleep 2
end
