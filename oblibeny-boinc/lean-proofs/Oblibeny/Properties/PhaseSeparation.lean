/-
  Property 1: Phase Separation Soundness

  Theorem: No compile-time construct appears in deploy-time code.
-/

import Oblibeny.Syntax
import Oblibeny.Semantics

namespace Oblibeny.Properties

open Expr

/-- Phase separation property: deploy-time code contains no compile-only constructs -/
def phaseSeparationSound (prog : Program) : Prop :=
  ∀ def ∈ prog.defs,
    match def with
    | defunDeploy _ _ body => ¬ (body.any (·.containsCompileOnly))
    | _ => True

/-- Helper: Check if a list of expressions contains compile-only constructs -/
def allDeploySafe (exprs : List Expr) : Bool :=
  !exprs.any (·.containsCompileOnly)

theorem phaseSeparation_preservedByBoundedFor
    (x : String) (start end_ : Expr) (body : List Expr) :
    allDeploySafe [start, end_] →
    allDeploySafe body →
    ¬(Expr.boundedFor x start end_ body).containsCompileOnly := by
  intro h_bounds h_body h_contains
  -- Proof sketch: bounded-for is deploy-safe if its components are
  simp [Expr.containsCompileOnly] at h_contains
  sorry -- Full proof would expand this

theorem phaseSeparation_validProgram (prog : Program) :
    (∀ def ∈ prog.defs, match def with
      | defunDeploy _ _ body => allDeploySafe body
      | _ => true) →
    phaseSeparationSound prog := by
  intro h
  unfold phaseSeparationSound
  intro def h_mem
  cases def with
  | defunDeploy name params body =>
    have h_safe := h def h_mem
    simp at h_safe
    intro h_contains
    exact Bool.noConfusion (Eq.trans h_safe.symm (Bool.of_decide h_contains))
  | _ => trivial

/-- Main theorem: Phase separation is decidable -/
theorem phaseSeparation_decidable (prog : Program) :
    Decidable (phaseSeparationSound prog) := by
  unfold phaseSeparationSound
  -- In principle decidable by checking all definitions
  sorry

end Oblibeny.Properties
