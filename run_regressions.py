import os
import subprocess

# Simple script to automate simulation and check for SVA errors
def run_simulation():
    print("--- Starting Apple-Style DV Regression ---")
    # Command to run your simulator (e.g., Icarus Verilog or Vivado)
    cmd = "iverilog -g2012 -o puf_sim puf_top.v puf_dv_top.sv puf_assertions.sv && vvp puf_sim"
    
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    
    if "error" in result.stdout.lower() or "Assertion" in result.stdout:
        print("RESULT: FAILED - Architectural violations detected.")
        print(result.stdout)
    else:
        print("RESULT: PASSED - All checkers and assertions cleared.")

if __name__ == "__main__":
    run_simulation()
