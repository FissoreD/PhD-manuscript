(*SNIP: add_module *)
module type Add = 
sig
  type t
  val plus : t -> t -> t
end
(*ENDSNIP: add_module *)

(*SNIP: add_nat_module *)
module AddNat : Add with type t = int = 
struct
  type t = int
  let plus = Int.add
end
(*ENDSNIP: add_nat_module *)

(*SNIP: add_R_module *)
module AddR : Add = struct
  type t = float
  let plus = Float.add
end
(*ENDSNIP: add_R_module *)

(*SNIP: add_pr_module *)
module AddProd (T1 : Add) (T2 : Add) : 
  Add with type t = T1.t * T2.t = 
struct
  type t = T1.t * T2.t
  let plus (a, b) (c, d) = 
    T1.plus a c, T2.plus b d
end
(*ENDSNIP: add_pr_module *)

(*SNIP: add_pr_nn_module *)
module AddProdNN = AddProd (AddNat) (AddNat)
(*ENDSNIP: add_pr_nn *)

let _ =   
(*SNIP: add_module_test *)
  AddProdNN.plus (1,2) (3,4)
(*ENDSNIP: add_module_test *)
