# 2024-03-13T18:32:33.943618
import vitis

client = vitis.create_client()
client.set_workspace(path="/media/tony/TDG_512/projects/axi_mcdma/sw/workspace2")

platform = client.create_platform_component(name = "u96_platform",hw = "/media/tony/TDG_512/projects/axi_mcdma/output_products/top_bd_wrapper.xsa",os = "standalone",cpu = "psu_cortexa53_0")

platform = client.get_platform_component(name="u96_platform")
status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "/media/tony/TDG_512/projects/axi_mcdma/sw/workspace2/u96_platform/export/u96_platform/u96_platform.xpfm",domain = "standalone_psu_cortexa53_0")

comp = client.get_component(name="hello_world")
status = comp.import_files(from_loc="/media/tony/TDG_512/projects/axi_mcdma/sw", files=["helloworld.c", "helpFunctions.c", "helpFunctions.h"], dest_dir_in_cmp = "src")

comp.build()

status = comp.import_files(from_loc="/media/tony/TDG_512/projects/axi_mcdma/sw", files=["platform.c", "platform.h"], dest_dir_in_cmp = "src")

comp.build()

comp = client.create_app_component(name="mcdma_ex",platform = "/media/tony/TDG_512/projects/axi_mcdma/sw/workspace2/u96_platform/export/u96_platform/u96_platform.xpfm",domain = "standalone_psu_cortexa53_0")

comp = client.get_component(name="mcdma_ex")
status = comp.import_files(from_loc="/media/tony/TDG_512/projects/axi_mcdma/sw", files=["helpFunctions.c", "helpFunctions.h", "mcdma_polled_adg.c", "mcdma_polled_ex.c"], dest_dir_in_cmp = "src")

comp.build()

comp.build()

vitis.dispose()

