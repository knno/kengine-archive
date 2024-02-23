function ken_scr_test_leaks(){
	// Test Leak 1: events.
	repeat (10000) {Kengine.utils.events.fire("awesome", {obj: "hii"});} // NO LEAKS! :D

	// Test Leak 2: Cscripts.
	var i = 10000;
	while (--i>0) {Kengine.utils.parser.interpret("print(\"arg\"); print(arg);", {arg: i})}; // NO LEAKS! :D

	return 5;
}

function ken_scr_test_custom_script(){
	var at_cscripts = Kengine.asset_types[$ KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME];
	var foo_cscript = new Kengine.Asset(at_cscripts, "kscr_foo", false, 1234);
	foo_cscript.src = "print_error(\"LOL!\");\n" + 
		"print(arguments);\n" +
		"print(array_get(arguments, 0));\n" +
		"array_set(arguments, 0, 588);\n" +
		"print(arguments[0]);\n" +
		"arguments[0] = 59;\n" +
		"print(array_get(arguments, 0));\n" +
		"return 69";
	foo_cscript.compile();

	return Kengine.utils.execute_script(foo_cscript, ["55", "66"]);
}

function ken_scr_test_yaml() {
	var yaml = ken_mods_parse_modtext("mod1", "tests/mods/mod1.yml");
	return yaml;
}

function ken_test_balls_collide() {
    if not test.is_testing {
        test.timer = 0;
        test.step_func = test.func;
        test.fixtures = [
            new Kengine.tests.Fixture("fixture-ball-object", function(){
                // Setup
            	var at_objects = Kengine.asset_types.object;
                var ball_asset;
                var ball_par_asset;

                var ball_par_obj_index = at_objects.assets.get_ind("obj_test_ball_parent", Kengine.cmps.cmp_val1_val2_index);
                if ball_par_obj_index == -1 {
                    ball_par_asset = new Kengine.Asset(at_objects, "obj_test_ball_parent", );
                }

                // Ball
                var ball_obj_index = at_objects.assets.get_ind("obj_test_ball", Kengine.cmps.cmp_val1_val2_index);
                if ball_obj_index == -1 {
                    ball_asset = new Kengine.Asset(at_objects, "obj_test_ball", );
                    ball_asset.parent = ball_par_asset;
                    ball_asset.sprite = spr_ball;
                    ball_asset.event_scripts = {
                        create: function() {
                            wrapper.instance.direction = choose(45, 135, 225, 315);
                            wrapper.instance.speed = 30;
                            wrapper.collided = false;
                            var ff = wrapper.instance.id;
                            show_debug_message($"A ball instance with ID: {ff} created.");
                        },
                        collision: function() {
                            wrapper.instance.x = wrapper.instance.xprevious;
                            wrapper.instance.y = wrapper.instance.yprevious;
                            wrapper.instance.direction += 180;
							wrapper.instance.image_blend = c_lime;
                            wrapper.collided = true;
                        },
                        step: function() {
							var inst = wrapper.instance;
                            if event_arg == ev_step_normal {
                                if inst.x > room_width {
                                    if inst.direction == 45 inst.direction = 135 else inst.direction = 225;
                                } else if inst.x < 0 {
                                    if inst.direction == 135 inst.direction = 45 else inst.direction = 315;
                                }

                                if inst.y > room_height {
                                    if inst.direction == 225 inst.direction = 135 else inst.direction = 45;
                                } else if inst.y < 0 {
                                    if inst.direction == 135 inst.direction = 225 else inst.direction = 315;
                                }
                            }
                        },
						draw: function() {
							var inst = wrapper.instance;
							with inst {
								if sprite_exists(sprite_index) draw_self();
							}
						}
                    }
                } else {
                    ball_asset = at_objects.assets.get(ball_obj_index);
                    show_debug_message("Asset already found.");
                }
                Kengine.tests.test_manager.ball_asset = ball_asset;

                // Instancing
                Kengine.tests.test_manager.ball_1 = Kengine.utils.instance_create(Kengine.tests.test_manager.ball_asset, 50,50);
				show_debug_message(Kengine.tests.test_manager.ball_1);
                Kengine.tests.test_manager.ball_2 = Kengine.utils.instance_create(Kengine.tests.test_manager.ball_asset, 200,300);
				// test.ball_1.instance.sprite_index = spr_ball;
				// test.ball_2.instance.sprite_index = spr_ball;

                if Kengine.utils.instance_exist(Kengine.tests.test_manager.ball_asset) {
                    show_debug_message("Balls are created.");
                }

                // ken_with(ball_par_asset, function(inst) {
                    // Any code.
					// show_debug_message(inst);
                // })

                }, function() { 
                    Kengine.tests.test_manager.ball_1.destroy();
                    Kengine.tests.test_manager.ball_2.destroy();
                    Kengine.tests.test_manager.ball_asset = undefined;
                }),
        ];
        return {fixtures: test.fixtures};
    }

    if test.timer > 600 {
		test.fail("No collision in 10 seconds!");
    } else {
        test.timer ++;
        if test_manager.ball_1.collided {
			test.done();
		}
    }
}

function ken_scr_test_ball() {
	static __opts = {
		private: true,
	};

	Kengine.console.echo(" - Running scr_test_ball");
	var at_objects = Kengine.asset_types.object;

	var ball_obj_index = at_objects.assets.get_ind("obj_test_ball", Kengine.cmps.cmp_val1_val2_name);
	Kengine.console.echo(" - Ball index: " + string(ball_obj_index));

	if ball_obj_index != -1 {
		var ball_obj = at_objects.assets.get(ball_obj_index);
		Kengine.console.echo(" - Ball object: " + string(ball_obj));
		var beach_ball_asset = new Kengine.Asset(at_objects, "obj_test_ball", false, 5123);

		Kengine.console.echo(" - Beach Ball Asset: " + string(beach_ball_asset));
		ball_obj.replace_by(beach_ball_asset);
	} else {
		Kengine.console.echo(" - Beach Ball Was not created.");
	}

	var new_ball = Kengine.utils.get_asset(at_objects, "obj_test_ball");
	Kengine.console.echo(" - New Ball: " +string(new_ball));

	var ball_1 = Kengine.utils.instance_create(new_ball, 50,50);

	return true;
}
