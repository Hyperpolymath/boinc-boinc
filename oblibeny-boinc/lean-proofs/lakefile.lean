import Lake
open Lake DSL

package oblibeny where
  -- Settings for the Oblibeny formal verification package

lean_lib Oblibeny where
  -- Main library for Oblibeny formalization

@[default_target]
lean_exe oblibeny_verifier where
  root := `Main
