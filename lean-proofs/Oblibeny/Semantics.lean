/-
  Oblibeny Operational Semantics

  This file defines the operational semantics of Oblibeny programs.
-/

import Oblibeny.Syntax

namespace Oblibeny

/-- Values are the results of evaluation -/
inductive Value where
  | int : Int → Value
  | bool : Bool → Value
  | closure : List String → List Expr → Environment → Value
  | nil : Value
  deriving Repr

/-- Environment maps variable names to values -/
def Environment := List (String × Value)

/-- Empty environment -/
def Environment.empty : Environment := []

/-- Look up a variable in the environment -/
def Environment.lookup (env : Environment) (x : String) : Option Value :=
  env.find? (fun (y, _) => x == y) |>.map (·.2)

/-- Extend environment with a new binding -/
def Environment.extend (env : Environment) (x : String) (v : Value) : Environment :=
  (x, v) :: env

/-- Store for mutable state -/
def Store := List (String × Value)

/-- Resource state tracking -/
structure ResourceState where
  time_remaining : Nat
  memory_remaining : Nat
  network_remaining : Nat
  deriving Repr

/-- Configuration: expression, environment, store, resources -/
structure Config where
  expr : Expr
  env : Environment
  store : Store
  resources : ResourceState
  deriving Repr

/-- Small-step operational semantics -/
inductive Step : Config → Config → Prop where
  | step_var (env : Environment) (store : Store) (res : ResourceState) (x : String) (v : Value) :
      env.lookup x = some v →
      Step
        ⟨Expr.var x, env, store, res⟩
        ⟨Expr.int 0, env, store, res⟩ -- Placeholder

  | step_bounded_for (env : Environment) (store : Store) (res : ResourceState)
      (x : String) (n₁ n₂ : Int) (body : List Expr) :
      n₁ < n₂ →
      Step
        ⟨Expr.boundedFor x (Expr.int n₁) (Expr.int n₂) body, env, store, res⟩
        ⟨Expr.int 0, env, store, res⟩ -- Placeholder for loop execution

/-- Multi-step evaluation -/
def eval (cfg : Config) (fuel : Nat) : Option Config :=
  match fuel with
  | 0 => some cfg
  | fuel' + 1 => none -- Would implement actual stepping

/-- A program terminates if evaluation reaches a value -/
def terminates (prog : Expr) (fuel : Nat) : Prop :=
  ∃ cfg : Config, eval ⟨prog, Environment.empty, [], ⟨0, 0, 0⟩⟩ fuel = some cfg

end Oblibeny
