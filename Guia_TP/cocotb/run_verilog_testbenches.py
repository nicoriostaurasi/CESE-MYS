import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
RTL_DIR = ROOT / "Guia_TP/MYS_CESE/MYS_CESE.srcs/sources_1/new"
TB_DIR = ROOT / "Guia_TP/MYS_CESE/MYS_CESE.srcs/sim_1/imports/new"
BUILD_DIR = Path(__file__).resolve().parent / "sim_build/verilog_testbenches"


def main() -> int:
    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    rtl_sources = sorted(RTL_DIR.glob("*.v"))
    testbenches = sorted(TB_DIR.glob("*_tb.v"))
    failures = []

    for testbench in testbenches:
        top = testbench.stem
        executable = BUILD_DIR / f"{top}.vvp"
        compile_command = [
            "iverilog", "-g2012", "-s", top, "-o", str(executable),
            *(str(source) for source in rtl_sources), str(testbench),
        ]
        compile_result = subprocess.run(compile_command, check=False)
        run_result = subprocess.run(["vvp", str(executable)], check=False) if compile_result.returncode == 0 else None
        passed = compile_result.returncode == 0 and run_result is not None and run_result.returncode == 0
        print(f"{top}: {'PASS' if passed else 'FAIL'}")
        if not passed:
            failures.append(top)

    print(f"\nTestbenches Verilog: {len(testbenches) - len(failures)}/{len(testbenches)} OK")
    if failures:
        print("Fallaron: " + ", ".join(failures))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
