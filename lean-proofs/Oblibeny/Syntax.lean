/-
  Oblibeny Syntax Formalization in Lean 4

  This file defines the abstract syntax of Oblibeny programs.
-/

namespace Oblibeny

/-- Types in Oblibeny -/
inductive Ty where
  | int32 : Ty
  | int64 : Ty
  | uint32 : Ty
  | uint64 : Ty
  | bool : Ty
  | string : Ty
  | void : Ty
  | array : Ty → Nat → Ty
  | capability : ResourceType → Ty
  | fn : List Ty → Ty → Ty
  deriving Repr, DecidableEq

/-- Resource types for capabilities -/
inductive ResourceType where
  | uart_tx
  | uart_rx
  | gpio
  | sensor_read
  | network_send
  deriving Repr, DecidableEq

/-- Phase of execution -/
inductive Phase where
  | compile : Phase
  | deploy : Phase
  deriving Repr, DecidableEq

/-- Expressions in Oblibeny -/
inductive Expr where
  | int : Int → Expr
  | bool : Bool → Expr
  | var : String → Expr
  | boundedFor : String → Expr → Expr → List Expr → Expr
  | defunDeploy : String → List String → List Expr → Expr
  | defunCompile : String → List String → List Expr → Expr
  | app : Expr → List Expr → Expr
  | let_ : String → Expr → Expr → Expr
  | if_ : Expr → Expr → Expr → Expr
  | set : String → Expr → Expr
  | withCapability : Expr → List Expr → Expr
  deriving Repr

/-- Check if an expression is compile-only -/
def Expr.isCompileOnly : Expr → Bool
  | defunCompile _ _ _ => true
  | _ => false

/-- Extract phase from expression -/
def Expr.phase : Expr → Phase
  | defunDeploy _ _ _ => Phase.deploy
  | defunCompile _ _ _ => Phase.compile
  | boundedFor _ _ _ _ => Phase.deploy
  | _ => Phase.deploy -- Default to deploy for safety

/-- Check if expression contains any compile-only construct -/
def Expr.containsCompileOnly : Expr → Bool
  | defunCompile _ _ _ => true
  | defunDeploy _ _ body => body.any (·.containsCompileOnly)
  | boundedFor _ start end body =>
      start.containsCompileOnly ||
      end.containsCompileOnly ||
      body.any (·.containsCompileOnly)
  | app f args =>
      f.containsCompileOnly || args.any (·.containsCompileOnly)
  | let_ _ e1 e2 => e1.containsCompileOnly || e2.containsCompileOnly
  | if_ cond t e => cond.containsCompileOnly || t.containsCompileOnly || e.containsCompileOnly
  | withCapability cap body => cap.containsCompileOnly || body.any (·.containsCompileOnly)
  | _ => false

/-- Program is a list of top-level definitions -/
structure Program where
  defs : List Expr
  budget : ResourceBudget
  deriving Repr

/-- Resource budget specification -/
structure ResourceBudget where
  time_ms : Nat
  memory_bytes : Nat
  network_bytes : Nat
  deriving Repr, DecidableEq

end Oblibeny
