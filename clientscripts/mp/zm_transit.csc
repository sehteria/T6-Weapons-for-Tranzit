#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zm_transit_classic;
#include clientscripts\mp\zm_transit_standard_station;
#include clientscripts\mp\zm_transit_standard_farm;
#include clientscripts\mp\zm_transit_standard_town;
#include clientscripts\mp\zm_transit_grief_station;
#include clientscripts\mp\zm_transit_grief_farm;
#include clientscripts\mp\zm_transit_grief_town;
#include clientscripts\mp\zm_transit_ffotd;
#include clientscripts\mp\zm_transit_bus;
#include clientscripts\mp\zm_transit_automaton;
#include clientscripts\mp\zombies\_zm_equip_turbine;
#include clientscripts\mp\zm_transit_fx;
#include clientscripts\mp\zm_transit_amb;
#include clientscripts\mp\zm_transit_gump;
#include clientscripts\mp\_teamset_cdc;
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_morsecode;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_weap_tazer_knuckles;
#include clientscripts\mp\zombies\_zm_weap_riotshield;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_weap_jetgun;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm_equipment;

init_gamemodes()
{
    add_map_gamemode( "zclassic", undefined, undefined );
    add_map_gamemode( "zgrief", undefined, undefined );
    add_map_gamemode( "zstandard", undefined, undefined );
    add_map_location_gamemode( "zclassic", "transit", clientscripts\mp\zm_transit_classic::precache, clientscripts\mp\zm_transit_classic::premain, clientscripts\mp\zm_transit_classic::main );
    add_map_location_gamemode( "zstandard", "transit", clientscripts\mp\zm_transit_standard_station::precache, undefined, clientscripts\mp\zm_transit_standard_station::main );
    add_map_location_gamemode( "zstandard", "farm", clientscripts\mp\zm_transit_standard_farm::precache, undefined, clientscripts\mp\zm_transit_standard_farm::main );
    add_map_location_gamemode( "zstandard", "town", clientscripts\mp\zm_transit_standard_town::precache, undefined, clientscripts\mp\zm_transit_standard_town::main );
    add_map_location_gamemode( "zgrief", "transit", clientscripts\mp\zm_transit_grief_station::precache, undefined, clientscripts\mp\zm_transit_grief_station::main );
    add_map_location_gamemode( "zgrief", "farm", clientscripts\mp\zm_transit_grief_farm::precache, undefined, clientscripts\mp\zm_transit_grief_farm::main );
    add_map_location_gamemode( "zgrief", "town", clientscripts\mp\zm_transit_grief_town::precache, undefined, clientscripts\mp\zm_transit_grief_town::main );
}

main()
{
    level thread clientscripts\mp\zm_transit_ffotd::main_start();
    level.default_start_location = "transit";
    level.default_game_mode = "zclassic";
    level._no_water_risers = 1;
    level.riser_fx_on_client = 1;
    level.setupcustomcharacterexerts = ::setup_personality_character_exerts;
    level.zombiemode_using_doubletap_perk = 1;
    level.zombiemode_using_juggernaut_perk = 1;
    level.zombiemode_using_marathon_perk = 1;
    level.zombiemode_using_revive_perk = 1;
    level.zombiemode_using_sleightofhand_perk = 1;
    level.zombiemode_using_tombstone_perk = 1;
    clientscripts\mp\zm_transit_bus::init_animtree();
    clientscripts\mp\zm_transit_bus::init_props_animtree();
    clientscripts\mp\zm_transit_automaton::init_animtree();
    clientscripts\mp\zombies\_zm_equip_turbine::init_animtree();
    start_zombie_stuff();

    if ( level.scr_zm_ui_gametype == "zclassic" )
        clientscripts\mp\zombies\_zm_equip_turbine::init();

    init_gamemodes();
    clientscripts\mp\zm_transit_fx::main();
    thread clientscripts\mp\zm_transit_amb::main();
    thread clientscripts\mp\zm_transit_gump::init_transit_gump();
    register_client_fields();
    register_client_flags();
    register_clientflag_callbacks();
    registerclientfield( "allplayers", "playerinfog", 1, 1, "int", ::infog_clientfield_cb, 0 );
    register_screecher_lights();
    level._override_eye_fx = level._effect["blue_eyes"];
    zombe_gametype_premain();
    claymores = getstructarray( "claymore_purchase", "targetname" );

    if ( isdefined( claymores ) )
    {
        foreach ( struct in claymores )
        {
            weapon_model = getstruct( struct.target, "targetname" );

            if ( isdefined( weapon_model ) )
                weapon_model.script_vector = vectorscale( ( 0, -1, 0 ), 90.0 );
        }
    }

    level thread clientscripts\mp\zm_transit_ffotd::main_end();
    waitforclient( 0 );
    level thread clientscripts\mp\zm_transit_bus::main();
    level._power_on = 0;
    clientscripts\mp\_teamset_cdc::level_init();
    level thread init_fog_vol_to_visionset();
    level thread set_fog_on_bus();
    level thread power_controlled_lights();

    if ( level.scr_zm_ui_gametype == "zclassic" )
    {
        if ( isdefined( level.createfxexploders ) )
            clientscripts\mp\_fx::activate_exploder( 1966 );

        setup_morsecode();
    }
}

setup_morsecode()
{
    clientscripts\mp\zombies\_zm_morsecode::init_morse_code();
    clientscripts\mp\zombies\_zm_morsecode::register_morse_code_location( level._effect["mc_trafficlight"], ( 1448, -766, 133.5 ), vectorscale( ( 0, 1, 0 ), 90.0 ) );
    clientscripts\mp\zombies\_zm_morsecode::register_morse_code_location( level._effect["mc_trafficlight"], ( 1144, -435, 121 ), ( 0, 0, 0 ) );
    clientscripts\mp\zombies\_zm_morsecode::register_morse_code_location( level._effect["mc_towerlight"], ( 7965, -460, 814 ), ( 0, 0, 0 ) );
    clientscripts\mp\zombies\_zm_morsecode::register_morse_code_location( level._effect["mc_towerlight"], ( 7328, -462, 1582 ), ( 0, 0, 0 ) );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "we shall prevail" );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "help me so i can help you" );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "the future is ours to destroy" );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "power is knowledge" );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "go to the light" );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "stay close to me" );
    clientscripts\mp\zombies\_zm_morsecode::add_message( "energy can only be transformed" );
}

power_rumble_cb( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
        self thread rumble_and_shake_the_player( localclientnum, fieldname );
    else
        self notify( "stop_power_rumble" );
}

rumble_and_shake_the_player( localclientnum, fieldname )
{
    self endon( "entityshutdown" );
    self endon( "stop_power_rumble" );

    for ( counter = 0; !counter || self getclientfieldtoplayer( fieldname ); counter++ )
    {
        if ( !self islocalplayer() || isspectating( localclientnum, 0 ) || isdefined( level.localplayers[localclientnum] ) && self getentitynumber() != level.localplayers[localclientnum] getentitynumber() )
            return;

        self playrumbleonentity( localclientnum, "grenade_rumble" );
        time = randomfloatrange( 0.5, 1 );

        if ( counter % 3 == 0 && randomint( 100 ) > 50 )
        {
            intensity = randomfloatrange( 0.3, 0.45 );
            self earthquake( intensity, time, self.origin, 100 );
        }

        end_time = gettime() + time * 1000;

        while ( gettime() < end_time )
        {
            wait 0.1;

            if ( randomint( 100 ) > 25 )
                self playrumbleonentity( localclientnum, "pullout_small" );
        }
    }

    self earthquake( 0.5, 1, self.origin, 100 );
    self playrumbleonentity( localclientnum, "grenade_rumble" );
}

infog_clientfield_cb( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
        self thread lerp_infog_alpha( 0 );
    else
        self thread lerp_infog_alpha( 1 );
}

lerp_infog_alpha( up )
{
    self notify( "stop_infog_lerp" );
    self endon( "stop_infog_lerp" );
    self endon( "entityshutdown" );

    if ( up )
    {
        for ( i = 0; i < 21; i++ )
        {
            self setalphafadeforname( i * 0.05 );
            wait 0.05;
        }
    }
    else
    {
        for ( i = 20; i > -1; i-- )
        {
            self setalphafadeforname( i * 0.05 );
            wait 0.05;
        }
    }
}

register_client_fields()
{
    if ( level.scr_zm_ui_gametype == "zclassic" )
    {
        registerclientfield( "vehicle", "the_bus_spawned", 1, 1, "int", ::bus_spawned, 0 );
        registerclientfield( "vehicle", "bus_flashing_lights", 1, 1, "int", clientscripts\mp\zm_transit_bus::bus_flashing_lights, 0 );
        registerclientfield( "vehicle", "bus_head_lights", 1, 1, "int", clientscripts\mp\zm_transit_bus::bus_head_lights, 0 );
        registerclientfield( "vehicle", "bus_brake_lights", 1, 1, "int", clientscripts\mp\zm_transit_bus::bus_brake_lights, 0 );
        registerclientfield( "vehicle", "bus_turn_signal_left", 1, 1, "int", clientscripts\mp\zm_transit_bus::bus_turnal_signal_left_lights, 0 );
        registerclientfield( "vehicle", "bus_turn_signal_right", 1, 1, "int", clientscripts\mp\zm_transit_bus::bus_turnal_signal_right_lights, 0 );
        registerclientfield( "toplayer", "power_rumble", 1, 1, "int", ::power_rumble_cb, 0 );
        registerclientfield( "allplayers", "screecher_sq_lights", 1, 1, "int", ::screecher_light_watcher, 0 );
        registerclientfield( "allplayers", "screecher_maxis_lights", 1, 1, "int", ::maxis_lights_watcher, 0 );
        registerclientfield( "allplayers", "sq_tower_sparks", 1, 1, "int", ::sq_tower_watcher, 0 );
    }
}

register_client_flags()
{

}

register_clientflag_callbacks()
{

}

start_zombie_stuff()
{
    level._uses_crossbow = 1;
    level.raygun2_included = 1;
    include_weapons();
    include_powerups();
    include_equipment_for_level();
    clientscripts\mp\zombies\_zm::init();
    clientscripts\mp\zombies\_zm_weap_tazer_knuckles::init();
    clientscripts\mp\zombies\_zm_weap_riotshield::init();
    level.legacy_cymbal_monkey = 1;
    clientscripts\mp\zombies\_zm_weap_cymbal_monkey::init();
    clientscripts\mp\zombies\_zm_weap_jetgun::init();
    clientscripts\mp\_visionset_mgr::vsmgr_register_overlay_info_style_burn( "zm_transit_burn", 1, 15, 2 );
}

include_weapons()
{
    gametype = getdvar( #"ui_gametype" );
    include_weapon( "knife_zm", 0 );
    include_weapon( "frag_grenade_zm", 0 );
    include_weapon( "claymore_zm", 0 );
    include_weapon( "sticky_grenade_zm", 0 );
    include_weapon( "m1911_zm", 0 );
    include_weapon( "m1911_upgraded_zm", 0 );
    include_weapon( "python_zm" );
    include_weapon( "python_upgraded_zm", 0 );
    include_weapon( "judge_zm" );
    include_weapon( "judge_upgraded_zm", 0 );
    include_weapon( "kard_zm" );
    include_weapon( "kard_upgraded_zm", 0 );
    include_weapon( "fiveseven_zm" );
    include_weapon( "fiveseven_upgraded_zm", 0 );
    include_weapon( "beretta93r_zm", 0 );
    include_weapon( "beretta93r_upgraded_zm", 0 );
    include_weapon( "fivesevendw_zm" );
    include_weapon( "fivesevendw_upgraded_zm", 0 );
    include_weapon( "ak74u_zm", 0 );
    include_weapon( "ak74u_upgraded_zm", 0 );
    include_weapon( "mp5k_zm", 0 );
    include_weapon( "mp5k_upgraded_zm", 0 );
    include_weapon( "qcw05_zm" );
    include_weapon( "qcw05_upgraded_zm", 0 );
    include_weapon( "870mcs_zm", 0 );
    include_weapon( "870mcs_upgraded_zm", 0 );
    include_weapon( "rottweil72_zm", 0 );
    include_weapon( "rottweil72_upgraded_zm", 0 );
    include_weapon( "saiga12_zm" );
    include_weapon( "saiga12_upgraded_zm", 0 );
    include_weapon( "srm1216_zm" );
    include_weapon( "srm1216_upgraded_zm", 0 );
    include_weapon( "m14_zm", 0 );
    include_weapon( "m14_upgraded_zm", 0 );
    include_weapon( "saritch_zm" );
    include_weapon( "saritch_upgraded_zm", 0 );
    include_weapon( "m16_zm", 0 );
    include_weapon( "m16_gl_upgraded_zm", 0 );
    include_weapon( "xm8_zm" );
    include_weapon( "xm8_upgraded_zm", 0 );
    include_weapon( "type95_zm" );
    include_weapon( "type95_upgraded_zm", 0 );
    include_weapon( "tar21_zm" );
    include_weapon( "tar21_upgraded_zm", 0 );
    include_weapon( "galil_zm" );
    include_weapon( "galil_upgraded_zm", 0 );
    include_weapon( "fnfal_zm" );
    include_weapon( "fnfal_upgraded_zm", 0 );
    include_weapon( "dsr50_zm" );
    include_weapon( "dsr50_upgraded_zm", 0 );
    include_weapon( "barretm82_zm" );
    include_weapon( "barretm82_upgraded_zm", 0 );
    include_weapon( "rpd_zm" );
    include_weapon( "rpd_upgraded_zm", 0 );
    include_weapon( "hamr_zm" );
    include_weapon( "hamr_upgraded_zm", 0 );
    include_weapon( "usrpg_zm" );
    include_weapon( "usrpg_upgraded_zm", 0 );
    include_weapon( "m32_zm" );
    include_weapon( "m32_upgraded_zm", 0 );
    include_weapon( "cymbal_monkey_zm" );
    include_weapon( "emp_grenade_zm", 0 );
    // Added weapons
    include_weapon( "uzi_zm" );
    include_weapon( "uzi_upgraded_zm", 0 );
    include_weapon( "thompson_zm" );
    include_weapon( "thompson_upgraded_zm", 0 );
    include_weapon( "ak47_zm" );
    include_weapon( "ak47_upgraded_zm", 0 );
    include_weapon( "mp40_stalker_zm" );
    include_weapon( "mp40_stalker_upgraded_zm", 0 );
    include_weapon( "scar_zm" );
    include_weapon( "scar_upgraded_zm", 0 );
    include_weapon( "mg08_zm" );
    include_weapon( "mg08_upgraded_zm", 0 );

    if ( gametype != "zgrief" )
    {
        include_weapon( "ray_gun_zm" );
        include_weapon( "ray_gun_upgraded_zm", 0 );
        include_weapon( "jetgun_zm", 0 );
        include_weapon( "riotshield_zm", 0 );
        include_weapon( "knife_ballistic_zm" );
        include_weapon( "knife_ballistic_upgraded_zm", 0 );
        include_weapon( "knife_ballistic_bowie_zm", 0 );
        include_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );

        if ( is_true( level.raygun2_included ) && !isdemoplaying() )
        {
            include_weapon( "raygun_mark2_zm", hasdlcavailable( "dlc3" ) );
            include_weapon( "raygun_mark2_upgraded_zm", 0 );
        }
    }
}

include_powerups()
{
    gametype = getdvar( #"ui_gametype" );
    include_powerup( "nuke" );
    include_powerup( "insta_kill" );
    include_powerup( "double_points" );
    include_powerup( "full_ammo" );
    include_powerup( "insta_kill_ug" );

    if ( gametype != "zgrief" )
        include_powerup( "carpenter" );

    if ( is_encounter() && gametype != "zgrief" )
        include_powerup( "minigun" );

    include_powerup( "teller_withdrawl" );
}

include_equipment_for_level()
{
    clientscripts\mp\zombies\_zm_equipment::include_equipment( "riotshield_zm" );
}

rotate_wind_turbine()
{
    turbine = getentarray( 0, "depot_turbine_rotor", "targetname" );

    if ( isdefined( turbine ) )
        array_thread( turbine, ::spin_transit_turbines );
}

spin_transit_turbines()
{
    while ( true )
    {
        self rotatepitch( 360, 15 );
        self waittill( "rotatedone" );
    }
}

init_fog_vol_to_visionset()
{
    init_fog_vol_to_visionset_monitor( "zm_transit_base", 2 );
    fog_vol_to_visionset_set_suffix( "_off" );
    fog_vol_to_visionset_set_info( 0, "zm_transit_base" );
    fog_vol_to_visionset_set_info( 1, "zm_transit_cornfield" );
    fog_vol_to_visionset_set_info( 2, "zm_transit_depot_ext", 2 );
    fog_vol_to_visionset_set_info( 3, "zm_transit_depot_int" );
    fog_vol_to_visionset_set_info( 4, "zm_transit_diner_ext" );
    fog_vol_to_visionset_set_info( 5, "zm_transit_diner_int" );
    fog_vol_to_visionset_set_info( 6, "zm_transit_farm_ext" );
    fog_vol_to_visionset_set_info( 7, "zm_transit_farm_int" );
    fog_vol_to_visionset_set_info( 8, "zm_transit_power_ext" );
    fog_vol_to_visionset_set_info( 9, "zm_transit_power_int" );
    fog_vol_to_visionset_set_info( 10, "zm_transit_town_ext" );
    fog_vol_to_visionset_set_info( 11, "zm_transit_town_int" );
    fog_vol_to_visionset_set_info( 12, "zm_transit_tunnel" );
    fog_vol_to_visionset_set_info( 510, "zm_transit_town_ext", 5 );
    fog_vol_to_visionset_set_info( 506, "zm_transit_farm_ext", 8 );
    fog_vol_to_visionset_set_info( 504, "zm_transit_diner_ext", 8 );
    fog_vol_to_visionset_set_info( 508, "zm_transit_power_ext", 8 );
    fog_vol_to_visionset_set_info( 501, "zm_transit_cornfield", 5 );
    fog_vol_to_visionset_set_info( 502, "zm_transit_depot_ext", 8 );
}

set_fog_on_bus()
{
    self endon( "entityshutdown" );

    while ( true )
    {
        level waittill( "OBS", who );
        setworldfogactivebank( who, 5 );
        level waittill( "LBS", who );
        setworldfogactivebank( who, 1 );
    }
}

transit_vision_change( ent_player )
{
    ent_player endon( "entityshutdown" );

    while ( true )
    {
        self waittill( "trigger", who );

        if ( !isdefined( who ) || !who islocalplayer() )
            continue;

        local_clientnum = who getlocalclientnumber();
        visionset = "zm_transit_base";

        if ( isdefined( self.script_string ) )
            visionset = self.script_string;

        if ( isdefined( who._previous_vision ) && visionset == who._previous_vision )
            continue;

        if ( isdefined( self.script_float ) )
            trans_time = self.script_float;
        else
            trans_time = 2;

        if ( !isdefined( who._previous_vision ) )
            who._previous_vision = visionset;
        else
            who clientscripts\mp\zombies\_zm::zombie_vision_set_remove( who._previous_vision, trans_time, local_clientnum );

        who clientscripts\mp\zombies\_zm::zombie_vision_set_apply( visionset, 1, trans_time, local_clientnum );
        who._previous_vision = visionset;
    }
}

power_controlled_lights()
{
    if ( isdefined( level.createfx_enabled ) && level.createfx_enabled == 1 )
        return;

    wait 0.2;
    on = 100;
    off = 101;
    on_sq = 401;
    off_sq = 400;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "busdepot" );
    on = 102;
    off = 103;
    on_sq = 403;
    off_sq = 402;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "diner" );
    on = 104;
    off = 105;
    on_sq = 405;
    off_sq = 404;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "forest" );
    on = 106;
    off = 107;
    on_sq = 407;
    off_sq = 406;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "cornfield" );
    on = 108;
    off = 109;
    on_sq = 409;
    off_sq = 408;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "powerstation" );
    on = 110;
    off = 111;
    on_sq = 411;
    off_sq = 410;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "huntershack" );
    on = 112;
    off = 113;
    on_sq = 413;
    off_sq = 412;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "townbridge" );
    on = 114;
    off = 115;
    on_sq = 415;
    off_sq = 414;
    level thread power_controlled_or_turbine( on, off, on_sq, off_sq, "bridgedepot" );

    if ( getdvar( #"ui_gametype" ) == "zclassic" )
        level thread sq_tower_sparks_init();

    while ( true )
    {
        if ( !level getclientfield( "zombie_power_on" ) )
        {
            level.power_on = 0;
            fog_vol_to_visionset_set_suffix( "_off" );
            clientscripts\mp\_fx::deactivate_exploder( 490 );
            level notify( "power_controlled_light" );
            players = getlocalplayers();

            for ( i = 0; i < players.size; i++ )
            {
                players[i] waittill_dobj( i );

                if ( !isdefined( players[i] getentitynumber() ) || !isdefined( level.localplayers[i] ) || !isdefined( level.localplayers[i] getentitynumber() ) )
                    continue;

                if ( !players[i] islocalplayer() || isspectating( i, 0 ) || players[i] getentitynumber() != level.localplayers[i] getentitynumber() )
                    continue;

                level.current_fog = 1;
                setworldfogactivebank( i, level.current_fog );
            }

            level waittill_any( "power_on", "pwr", "ZPO" );
        }

        level.power_on = 1;

        if ( getdvar( #"ui_gametype" ) == "zclassic" )
            level thread turbine_door_sparks_init();

        fog_vol_to_visionset_set_suffix( "_on" );
        clientscripts\mp\_fx::activate_exploder( 490 );
        level notify( "power_controlled_light" );
        players = getlocalplayers();

        for ( i = 0; i < players.size; i++ )
        {
            players[i] waittill_dobj( i );

            if ( !isdefined( players[i] getentitynumber() ) || !isdefined( level.localplayers[i] ) || !isdefined( level.localplayers[i] getentitynumber() ) )
                continue;

            if ( !players[i] islocalplayer() || isspectating( i, 0 ) || players[i] getentitynumber() != level.localplayers[i] getentitynumber() )
                continue;

            level.current_fog = 8;
            setworldfogactivebank( i, level.current_fog );
            vision_trigs = getentarray( i, "vision_trig", "targetname" );

            if ( isdefined( vision_trigs ) )
            {
                foreach ( trig in vision_trigs )
                {
                    if ( isdefined( trig.script_string ) && trig.script_string == "zm_transit_depot_int_off" )
                        trig.script_string = "zm_transit_depot_int_on";

                    if ( isdefined( trig.script_string ) && trig.script_string == "zm_transit_diner_int_off" )
                        trig.script_string = "zm_transit_diner_int_on";

                    if ( isdefined( trig.script_string ) && trig.script_string == "zm_transit_town_int_off" )
                        trig.script_string = "zm_transit_town_int_on";

                    if ( isdefined( trig.script_string ) && trig.script_string == "zm_transit_power_int_off" )
                        trig.script_string = "zm_transit_power_int_on";

                    if ( isdefined( trig.script_string ) && trig.script_string == "zm_transit_tunnel_off" )
                        trig.script_string = "zm_transit_tunnel_on";
                }
            }
        }

        level waittill_any( "pwo", "ZPOff" );
    }
}

sq_tower_sparks_init()
{
    while ( !isdefined( level.sq_tower_complete ) )
    {
        clientscripts\mp\_fx::deactivate_exploder( 416 );
        level waittill_any( "power_on", "pwr" );
        clientscripts\mp\_fx::activate_exploder( 416 );
        level waittill( "pwo" );
    }

    clientscripts\mp\_fx::deactivate_exploder( 416 );
}

turbine_door_sparks_init()
{
    wire = getrope( "power_line_depot" );
    level thread turbine_door_sparks( wire );
    wire2 = getrope( "power_line_diner" );
    level thread turbine_door_sparks( wire2 );
    wire3 = getrope( "power_line_farm" );
    level thread turbine_door_sparks( wire3 );
    wire4 = getrope( "power_line_town" );
    level thread turbine_door_sparks( wire4 );
}

turbine_door_sparks( wire )
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "entityshutdown" );

    while ( level.power_on )
    {
        players = getlocalplayers();

        for ( i = 0; i < players.size; i++ )
        {
            pos = ropegetposition( wire, 1.0 );
            playfx( i, level._effect["fx_zmb_tranzit_spark_blue_lg_os"], pos );
        }

        waitrealtime( randomfloatrange( 3, 10 ) );
    }
}

register_screecher_lights()
{
    level.safety_lights = getstructarray( "screecher_escape", "targetname" );
    level.safety_lights_callbacks = [];

    for ( i = 0; i < level.safety_lights.size; i++ )
    {
        safety = level.safety_lights[i];
        name = safety.script_noteworthy;

        if ( !isdefined( name ) )
            name = "light_" + i;

        clientfieldname = "screecher_light_" + name;
        level.safety_lights_callbacks[clientfieldname] = safety;
        registerclientfield( "world", clientfieldname, 1, 1, "int", ::safety_light_callback, 0 );
    }
}

safety_light_callback( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    safety = level.safety_lights_callbacks[fieldname];

    if ( isdefined( safety ) )
    {
        if ( is_true( newval ) )
            safety notify( "power_on" );
        else
            safety notify( "power_off" );
    }
    else
    {

    }
}

find_safety_light( name )
{
    light = undefined;

    foreach ( safety in level.safety_lights )
    {
        if ( safety.script_noteworthy == name )
        {
            light = safety;
            break;
        }
    }

    return light;
}

sq_tower_watcher( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
        level.sq_tower_complete = 1;
    else
        level.sq_tower_complete = undefined;
}

maxis_lights_watcher( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
        level.light_max_sq = 1;
    else
        level.light_max_sq = undefined;
}

screecher_light_watcher( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval == 1 )
        level.light_ric_sq = 1;
    else
        level.light_ric_sq = undefined;
}

power_controlled_or_turbine( on, off, on_sq, off_sq, name )
{
    wait 1;
    lightstruct = find_safety_light( name );

    while ( true )
    {
        if ( isdefined( level.light_ric_sq ) )
        {
            clientscripts\mp\_fx::deactivate_exploder( on );
            clientscripts\mp\_fx::deactivate_exploder( on_sq );
            clientscripts\mp\_fx::deactivate_exploder( off_sq );
            clientscripts\mp\_fx::activate_exploder( off );
        }

        if ( isdefined( level.light_max_sq ) )
        {
            clientscripts\mp\_fx::deactivate_exploder( on );
            clientscripts\mp\_fx::deactivate_exploder( off );
            clientscripts\mp\_fx::deactivate_exploder( on_sq );
            clientscripts\mp\_fx::activate_exploder( off_sq );
        }
        else
        {
            clientscripts\mp\_fx::deactivate_exploder( on );
            clientscripts\mp\_fx::deactivate_exploder( on_sq );
            clientscripts\mp\_fx::deactivate_exploder( off_sq );
            clientscripts\mp\_fx::activate_exploder( off );
        }

        lightstruct thread sq_maxis_lights_on( on, off, on_sq, off_sq );
        lightstruct notify( "sound_stopped" );

        if ( isdefined( lightstruct ) )
            lightstruct waittill( "power_on" );
        else
            level waittill_any( "power_on", "pwr" );

        level notify( "SafeLightOn" );

        if ( isdefined( level.light_ric_sq ) )
        {
            clientscripts\mp\_fx::deactivate_exploder( off );
            clientscripts\mp\_fx::deactivate_exploder( on );
            clientscripts\mp\_fx::deactivate_exploder( off_sq );
            clientscripts\mp\_fx::activate_exploder( on_sq );
        }

        if ( isdefined( level.light_max_sq ) )
        {
            clientscripts\mp\_fx::deactivate_exploder( off );
            clientscripts\mp\_fx::deactivate_exploder( on_sq );
            clientscripts\mp\_fx::deactivate_exploder( off_sq );
            clientscripts\mp\_fx::activate_exploder( on );
        }
        else
        {
            clientscripts\mp\_fx::deactivate_exploder( off );
            clientscripts\mp\_fx::deactivate_exploder( on_sq );
            clientscripts\mp\_fx::deactivate_exploder( off_sq );
            clientscripts\mp\_fx::activate_exploder( on );
        }

        lightstruct thread sq_screecher_light_on( on, off, on_sq, off_sq );

        if ( isdefined( lightstruct ) )
            lightstruct waittill( "power_off" );
        else
            level waittill( "pwo" );

        level notify( "SafeLightOff" );
    }
}

sq_maxis_lights_on( on, off, on_sq, off_sq )
{
    self endon( "power_on" );
    level endon( "SafeLightOn" );
    level endon( "pwr" );
    level endon( "power_on" );
    sq_max_on = undefined;

    while ( !isdefined( level.light_max_sq ) )
        wait 1;

    while ( isdefined( level.light_max_sq ) )
    {
        if ( !isdefined( sq_max_on ) )
        {
            sq_max_on = 1;
            clientscripts\mp\_fx::deactivate_exploder( off );
            clientscripts\mp\_fx::deactivate_exploder( on );
            clientscripts\mp\_fx::deactivate_exploder( on_sq );
            clientscripts\mp\_fx::activate_exploder( off_sq );
        }

        wait 1;
    }
}

sq_screecher_light_on( on, off, on_sq, off_sq )
{
    self endon( "power_off" );
    level endon( "SafeLightOff" );
    level endon( "pwo" );
    sq_ric_on = undefined;

    while ( !isdefined( level.light_ric_sq ) )
        wait 1;

    self loop_fx_sound( 0, "zmb_safety_light_sidequest", self.origin, "sound_stopped" );

    while ( isdefined( level.light_ric_sq ) )
    {
        if ( !isdefined( sq_ric_on ) )
        {
            sq_ric_on = 1;
            clientscripts\mp\_fx::deactivate_exploder( off );
            clientscripts\mp\_fx::deactivate_exploder( on );
            clientscripts\mp\_fx::deactivate_exploder( off_sq );
            clientscripts\mp\_fx::activate_exploder( on_sq );
        }

        wait 1;
    }

    self notify( "sound_stopped" );
}

setup_personality_character_exerts()
{
    level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
    level.exert_sounds[1]["playerbreathinsound"][1] = "vox_plr_0_exert_inhale_1";
    level.exert_sounds[1]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale_2";
    level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
    level.exert_sounds[2]["playerbreathinsound"][1] = "vox_plr_0_exert_inhale_1";
    level.exert_sounds[2]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale_2";
    level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
    level.exert_sounds[3]["playerbreathinsound"][1] = "vox_plr_2_exert_inhale_1";
    level.exert_sounds[3]["playerbreathinsound"][2] = "vox_plr_2_exert_inhale_2";
    level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
    level.exert_sounds[4]["playerbreathinsound"][1] = "vox_plr_3_exert_inhale_1";
    level.exert_sounds[4]["playerbreathinsound"][2] = "vox_plr_3_exert_inhale_2";
    level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
    level.exert_sounds[1]["playerbreathoutsound"][1] = "vox_plr_0_exert_exhale_1";
    level.exert_sounds[1]["playerbreathoutsound"][2] = "vox_plr_0_exert_exhale_2";
    level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
    level.exert_sounds[2]["playerbreathoutsound"][1] = "vox_plr_1_exert_exhale_1";
    level.exert_sounds[2]["playerbreathoutsound"][2] = "vox_plr_1_exert_exhale_2";
    level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
    level.exert_sounds[3]["playerbreathoutsound"][1] = "vox_plr_2_exert_exhale_1";
    level.exert_sounds[3]["playerbreathoutsound"][2] = "vox_plr_2_exert_exhale_2";
    level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
    level.exert_sounds[4]["playerbreathoutsound"][1] = "vox_plr_3_exert_exhale_1";
    level.exert_sounds[4]["playerbreathoutsound"][2] = "vox_plr_3_exert_exhale_2";
    level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
    level.exert_sounds[1]["playerbreathgaspsound"][1] = "vox_plr_0_exert_exhale_1";
    level.exert_sounds[1]["playerbreathgaspsound"][2] = "vox_plr_0_exert_exhale_2";
    level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
    level.exert_sounds[2]["playerbreathgaspsound"][1] = "vox_plr_1_exert_exhale_1";
    level.exert_sounds[2]["playerbreathgaspsound"][2] = "vox_plr_1_exert_exhale_2";
    level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
    level.exert_sounds[3]["playerbreathgaspsound"][1] = "vox_plr_2_exert_exhale_1";
    level.exert_sounds[3]["playerbreathgaspsound"][2] = "vox_plr_2_exert_exhale_2";
    level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
    level.exert_sounds[4]["playerbreathgaspsound"][1] = "vox_plr_3_exert_exhale_1";
    level.exert_sounds[4]["playerbreathgaspsound"][2] = "vox_plr_3_exert_exhale_2";
    level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
    level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
    level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
    level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
    level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
    level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
    level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
    level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
    level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
    level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
    level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
    level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
    level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
    level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
    level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
    level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
    level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
    level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
    level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
    level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
    level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
    level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
    level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
    level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
    level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
    level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
    level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
    level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
    level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
    level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
    level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
    level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
    level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
    level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
    level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
    level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
    level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
    level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
    level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
    level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
    level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
    level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
    level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
    level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
    level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
    level.exert_sounds[2]["mantlesoundplayer"][6] = "vox_plr_1_exert_grunt_6";
    level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
    level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
    level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
    level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
    level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
    level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
    level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
    level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
    level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
    level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
    level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_3";
    level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_4";
    level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_5";
    level.exert_sounds[4]["mantlesoundplayer"][6] = "vox_plr_3_exert_grunt_6";
    level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
    level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
    level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
    level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
    level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
    level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_knife_swipe_5";
    level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
    level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
    level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
    level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
    level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
    level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_knife_swipe_5";
    level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
    level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
    level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
    level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
    level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
    level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_knife_swipe_5";
    level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
    level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
    level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
    level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
    level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
    level.exert_sounds[4]["meleeswipesoundplayer"][5] = "vox_plr_3_exert_knife_swipe_5";
    level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
    level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
    level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
    level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
    level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
    level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
    level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
    level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
    level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
    level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
    level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
    level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
    level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
    level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
    level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
    level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}
