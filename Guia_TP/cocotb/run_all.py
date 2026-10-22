import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


CASES = [
    ("adder_1_bit", "test_adder_1_bit", ""),
    ("adder_4_bits", "test_adder_4_bits", ""),
    ("barrel_shifter", "test_barrel_shifter", ""),
    ("barrel_shifter_mux", "test_barrel_shifter_mux", ""),
    ("contador_N_clk", "test_contador_N_clk", "N=5"),
    ("contador_bcd", "test_contador_bcd", ""),
    ("contador_bcd_1_seg", "test_contador_bcd_1_seg", "SYS_CLK=5"),
    ("contador_bcd_4_digitos", "test_contador_bcd_4_digitos", ""),
    ("contador_bcd_comportamiento", "test_contador_bcd_comportamiento", ""),
    ("contador_binario_4_bits", "test_contador_binario_4_bits", ""),
    (
        "contador_binario_4_bits_comportamiento",
        "test_contador_binario_4_bits_comportamiento",
        "",
    ),
    (
        "contador_binario_N_bits_estructural",
        "test_contador_binario_N_bits_estructural",
        "N=5",
    ),
    (
        "contador_binario_N_bits_comportamiento",
        "test_contador_binario_N_bits_comportamiento",
        "N=5",
    ),
    ("ffd", "test_ffd", ""),
    ("mux_2_a_1", "test_mux_2_a_1", ""),
    ("reg_desp_comportamiento", "test_reg_desp_comportamiento", ""),
    ("reg_desp_estructural", "test_reg_desp_estructural", ""),
    ("sum_res_4_bits", "test_sum_res_4_bits", ""),
]


def junit_passed(path: Path) -> bool:
    root = ET.parse(path).getroot()
    return not root.findall(".//failure") and not root.findall(".//error")


def main() -> int:
    results_dir = Path("results")
    results_dir.mkdir(exist_ok=True)
    failures = []

    for top, module, parameters in CASES:
        print(f"\n=== {top} ===", flush=True)
        # Cada caso se recompila para que los overrides de parametros no
        # reutilicen un ejecutable construido anteriormente con otros valores.
        shutil.rmtree(Path("sim_build") / top, ignore_errors=True)
        command = [
            "make",
            "sim",
            f"TOPLEVEL={top}",
            f"MODULE={module}",
            f"PARAMETERS={parameters}",
        ]
        completed = subprocess.run(command, check=False)
        result_file = Path("results.xml")
        destination = results_dir / f"{top}.xml"
        if result_file.exists():
            shutil.copy2(result_file, destination)

        if completed.returncode != 0 or not result_file.exists() or not junit_passed(result_file):
            failures.append(top)

    print(f"\nSuite: {len(CASES) - len(failures)}/{len(CASES)} tests OK")
    if failures:
        print("Fallaron: " + ", ".join(failures))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
