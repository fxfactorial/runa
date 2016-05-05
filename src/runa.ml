(** Runa is a collection of helper functions for js_of_ocaml
    programs. *)

(** Easy access of field by name from JS Object *)
let ( <!> ) obj field = Js.Unsafe.get obj field

(** Wrap your OCaml function to JS with this *)
let ( !@ ) f = Js.wrap_callback f

(** Alias of Js.Unsafe.inject *)
let ( !! ) o = Js.Unsafe.inject o

(** Try to get a string out of given Object *)
let stringify o = Js._JSON##stringify o |> Js.to_string

(** Alias of Js.Unsafe.meth_call*)
let m = Js.Unsafe.meth_call

(** Combine two JS objects into one *)
let merge a b : < .. > Js.t = Js.Unsafe.global##.Object##assign a b

(** Create a JS object out of a Jstable *)
let object_of_table t =
  let js_keys = Jstable.keys t in
  let values =
    js_keys
    |> List.map
      (fun k -> (Jstable.find t k |> Js.Optdef.get)
          (fun () -> assert false))
  in
  List.map2 (fun k v -> (Js.to_string k, v)) js_keys values
  |> Array.of_list
  |> Js.Unsafe.obj

(** Set the global variable DEBUG_VAR to whatever object you
    provide, useful during debugging *)
let debug item =
  (Js.Unsafe.global##.DEBUG_VAR := item) |> ignore

(** Log any object to the console *)
let log l =
  Firebug.console##log l

(** In [set_interval ~every cb], call !{cb} every given seconds.*)
let set_interval ~every:float (callback: unit -> unit) =
  Dom_html.window##setInterval !@callback float

(** Call your function with the scope of JavaScript's this object,
    very useful *)
let with_this f = !!(Js.wrap_meth_callback f)

(** Turn JavaScript string array into OCaml list of string *)
let to_string_list g =
  g |> Js.str_array |> Js.to_array |> Array.map Js.to_string |> Array.to_list

(** Turn OCaml list of strings into JavaScript string array *)
let of_string_list g =
  g |> Array.of_list |> Array.map Js.string |> Js.array

(** require for CommonJS environments *)
let require s =
  Js.Unsafe.fun_call
    (Js.Unsafe.js_expr "require")
    [|Js.Unsafe.inject (Js.string s)|]

(** Parse a string as JSON *)
let json_parse s = Js._JSON##parse (s |> Js.string)

(** Get all keys of an Object *)
let keys obj =
  m (Js.Unsafe.variable "Object") "keys" [|obj|]
  |> Js.to_array |> Array.map Js.to_string |> Array.to_list

(** For each item in the object, call function and ignore results *)
let for_each_iter ~f obj =
  keys obj |> List.iter (fun k -> f (Js.Unsafe.get obj k)
                                  |> ignore)

(** For each item in the object, call function and keep results *)
let for_each_map ~f obj =
  keys obj |> List.map (fun k -> f k (Js.Unsafe.get obj k))

(** Get the current UNIX time *)
let time_now () = (new%js Js.date_now)##getTime
