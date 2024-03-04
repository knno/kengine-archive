#region callables

function ken_scr_test_leaks(){
	// Test Leak 1: events.
	repeat (10000) {__KengineEventUtils.Fire("awesome", {obj: "hii"});} // NO LEAKS! :D

	// Test Leak 2: Cscripts.
	var i = 10000;
	while (--i>0) {__KengineParserUtils.Interpret("var dummy_var; dummy_var = string(arg);", {arg: i})}; // NO LEAKS! :D

	return true;
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
	foo_cscript.Compile();

	return Kengine.Utils.Execute(foo_cscript, ["55", "66"]);
}

function ken_scr_test_ball() {

	Kengine.console.echo(" - Running scr_test_ball");
	var at_objects = Kengine.asset_types.object;

	var ball_obj_index = at_objects.assets.GetInd("obj_ken_test_beach_ball", Kengine.Utils.Cmps.cmp_val1_val2_name);
	Kengine.console.echo(" - Beach Ball index: " + string(ball_obj_index));

	if ball_obj_index != -1 {
		var ball_obj = at_objects.assets.Get(ball_obj_index);
		Kengine.console.echo(" - Beach Ball object: " + string(ball_obj));
		var beach_ball_asset = new Kengine.Asset(at_objects, "obj_ken_test_beach_ball", false, 5123);

		Kengine.console.echo(" - Beach Ball Asset: " + string(beach_ball_asset));
		ball_obj.ReplaceBy(beach_ball_asset);
	} else {
		Kengine.console.echo(" - Beach Ball was not created.");
		return;
	}

	var new_ball = Kengine.Utils.GetAsset(at_objects, "obj_ken_test_beach_ball");
	Kengine.console.echo(" - New Ball: " +string(new_ball));

	var ball_1 = Kengine.Utils.Instance.CreateDepth(new_ball, 0, 50,50);

	return true;
}

#endregion callables

#region tests

function ken_test_foo1_foo() {
    if not test.is_testing {
        var fixtures = [
			new Kengine.Extensions.Tests.Fixture("fixture01", function(){ __kengine_log("Fixture01 setup!")}, function(){ __kengine_log("Fixture01 cleanup!")}),
        ];
        return {fixtures};
    }

    test.AssertEqual("hi", "hi");
    test.Done();
}

function ken_test_foo1_bar() {
    if not test.is_testing {
        var fixtures = [
            new Kengine.Extensions.Tests.Fixture("fixture02", function(){ __kengine_log("Fixture02 setup!")}, function(){ __kengine_log("Fixture02 cleanup!")}),
        ];
        return {fixtures};
    }

    test.AssertEqual("hi", "hi");
    test.AssertEqual("hi", "hi");
    test.Done();
}

function ken_test_foo1_baz() {
    if not test.is_testing {
        test.foo1baz = 0;
        test.step_func = test.func;
        return {};
    }

    if test.foo1baz > 100 {
        test.Done();
    } else {
        // test.AssertEqual(3, test.foo1baz); fails the test.
        test.foo1baz ++;
        if test.foo1baz mod 10 == 1{
            test.AssertEqual(true, true);
        }
    }
}

function ken_test_balls_collide() {
    if not test.is_testing {
        test.timer = 0;
        test.step_func = test.func;
        test.fixtures = [
            new Kengine.Extensions.Tests.Fixture("fixture-ball-object", function(){
                // Setup
                __kengine_log("Balls are being setup.");
            	var at_objects = Kengine.asset_types.object;
                var ball_asset;
                var ball_par_asset;

                var ball_par_obj_index = at_objects.assets.GetInd("obj_ken_test_ball_parent", Kengine.Utils.Cmps.cmp_val1_val2_index);
                if ball_par_obj_index == -1 {
                    ball_par_asset = new Kengine.Asset(at_objects, "obj_ken_test_ball_parent");
                }

                // Ball
                var ball_obj_index = at_objects.assets.GetInd("obj_ken_test_ball", Kengine.Utils.Cmps.cmp_val1_val2_index);
                if ball_obj_index == -1 {
                    ball_asset = new Kengine.Asset(at_objects, "obj_ken_test_ball");
                    ball_asset.parent = ball_par_asset;
                    ball_asset.sprite = spr_ken_ball;
                    ball_asset.event_scripts = {
                        create: function() {
							//wrapper.asset = Kengine.Utils.GetAsset("object", "obj_ken_test_ball");
                            wrapper.instance.direction = choose(45, 135, 225, 315);
                            wrapper.instance.speed = 30;
                            wrapper.collided = false;
                            var ff = wrapper.instance.id;
                            __kengine_log($"A ball instance with ID: {ff} created.");
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
                        },
						draw: function() {
							var inst = wrapper.instance;
							with inst {
								if sprite_exists(sprite_index) draw_self();
							}
						}
                    }
                } else {
                    ball_asset = at_objects.assets.Get(ball_obj_index);
                    __kengine_log("Asset already found.");
                }
                Kengine.Extensions.Tests.test_manager.ball_asset = ball_asset;

                // Instancing
                Kengine.Extensions.Tests.test_manager.ball_1 = Kengine.Utils.Instance.CreateDepth(50, 50, 0, ball_asset);
                Kengine.Extensions.Tests.test_manager.ball_2 = Kengine.Utils.Instance.CreateDepth(200, 300, 0, ball_asset);
				// test.ball_1.instance.sprite_index = spr_ball;
				// test.ball_2.instance.sprite_index = spr_ball;

                if Kengine.Utils.Instance.Exists(ball_asset) {
                    __kengine_log("Balls are created.");
                }

                // ken_with(ball_par_asset, function(inst) {
                    // Any code.
					// __kengine_log(inst);
                // })

                }, function() {
                    Kengine.Extensions.Tests.test_manager.ball_1.Destroy();
                    Kengine.Extensions.Tests.test_manager.ball_2.Destroy();
                    Kengine.Extensions.Tests.test_manager.ball_asset = undefined;
                }),
        ];
        return {fixtures: test.fixtures};
    }

    if test.timer > 600 {
		test.Fail("No collision in 10 seconds!");
    } else {
        test.timer ++;
		if struct_exists(test_manager.ball_1, "collided") {
	        if test_manager.ball_1.collided {
				test.Done();
			}
		}
    }
}

// TODO Enable once mods are rewritten
function __old__ken_test_mods_enabling_disabling() {
	// TODO Enable once mods are rewritten
	if not test.is_testing {
		var fixtures = [
			new Kengine.Extensions.Tests.Fixture("fixture-add-mods", function() {
				Kengine.Extensions.Tests.test_manager.testing_mods = [];
				Kengine.Extensions.Tests.test_manager.testing_mods[array_length(Kengine.Extensions.Tests.test_manager.testing_mods)] = new __KengineMods.Mod("Kawazaki-01");
				Kengine.Extensions.Tests.test_manager.testing_mods[array_length(Kengine.Extensions.Tests.test_manager.testing_mods)] = new __KengineMods.Mod("Kawazaki-02");
				Kengine.Extensions.Tests.test_manager.testing_mods[array_length(Kengine.Extensions.Tests.test_manager.testing_mods)] = new __KengineMods.Mod("Kawazaki-03", undefined, ["Kawazaki-01"]);
				// Creating mods makes it a found mod automatically.
				
			}, function() {
				var i = 3;
				while --i > 0 {
					__KengineMods.mod_manager.DisableMod(Kengine.Extensions.Tests.test_manager.testing_mods[i], 2);
				}
			}),
		];
		return {fixtures}
	}
	var mods = __KengineTests.test_manager.testing_mods;
	test.AssertEqual(mods[0].enabled, false);
	test.AssertEqual(mods[1].enabled, false);
	test.AssertEqual(mods[2].enabled, false);
	__KengineMods.mod_manager.EnableMod("Kawazaki-01");
	test.AssertEqual(mods[0].enabled, true);
	test.AssertEqual(mods[1].enabled, false);
	test.AssertEqual(mods[2].enabled, false);
	__KengineMods.mod_manager.DisableMod("Kawazaki-01");
	test.AssertEqual(mods[0].enabled, false);
	test.AssertEqual(mods[1].enabled, false);
	test.AssertEqual(mods[2].enabled, false);
	__KengineMods.mod_manager.EnableMod("Kawazaki-03", 2);
	test.AssertEqual(mods[0].enabled, true);
	test.AssertEqual(mods[1].enabled, false);
	test.AssertEqual(mods[2].enabled, true);
	__KengineMods.mod_manager.DisableMod("Kawazaki-01", 2);
	test.AssertEqual(mods[0].enabled, false);
	test.AssertEqual(mods[1].enabled, false);
	test.AssertEqual(mods[2].enabled, false);
	__KengineMods.mod_manager.EnableMod("Kawazaki-03", 1);
	__KengineMods.mod_manager.DisableMod("Kawazaki-01", 2); // Disables dependants (03)
	test.AssertEqual(mods[0].enabled, false);
	test.AssertEqual(mods[1].enabled, false);
	test.AssertEqual(mods[2].enabled, false);
	test.Done();
}

#endregion tests
