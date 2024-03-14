#!/usr/bin/env python3
import vitis

client = vitis.create_client()
client.set_workspace(path="./workspace3")

platform = client.create_platform_component(name = "u96_platform",hw = "../output_products/top_bd_wrapper.xsa",os = "standalone",cpu = "psu_cortexa53_0")

platform = client.get_platform_component(name="u96_platform")
status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "./workspace3/u96_platform/export/u96_platform/u96_platform.xpfm",domain = "standalone_psu_cortexa53_0")

comp = client.get_component(name="hello_world")
status = comp.import_files(from_loc="./", files=["helloworld.c", "helpFunctions.c", "helpFunctions.h", "platform.c", "platform.h"], dest_dir_in_cmp = "src")

comp.build()

comp = client.create_app_component(name="mcdma_ex",platform = "./workspace3/u96_platform/export/u96_platform/u96_platform.xpfm",domain = "standalone_psu_cortexa53_0")

comp = client.get_component(name="mcdma_ex")
status = comp.import_files(from_loc="./", files=["helpFunctions.c", "helpFunctions.h", "mcdma_polled_adg.c"], dest_dir_in_cmp = "src")

comp.build()

vitis.dispose()

