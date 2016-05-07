(** Runa is a collection of helper functions for js_of_ocaml
    programs. *)

(** Easy access of field by name from JS Object *)
val ( <!> ) : 'a -> string -> 'c

(** Safe version of <!> *)
val ( <*> ) : 'a -> string -> 'c option

(** Wrap your OCaml function to JS with this *)
val ( !@ ) : ('a -> 'b) -> ('c, 'a -> 'b) Js.meth_callback

(** Alias of Js.Unsafe.inject *)
val ( !! ) : 'a -> Js.Unsafe.any

(** Try to get a string out of given Object *)
val stringify : _ Js.t -> string

(** Alias of Js.Unsafe.meth_call*)
val m : _ Js.t -> string -> Js.Unsafe.any array -> 'b

(** Combine two JS objects into one *)
val merge : _ Js.t -> _ Js.t -> < .. > Js.t

(** Create a JS object out of a Jstable *)
val object_of_table : Js.Unsafe.any Jstable.t -> 'a

(** Set the global variable DEBUG_VAR to whatever object you
    provide, useful during debugging *)
val debug : 'a -> unit

(** Log any object to the console *)
val log : 'a -> unit

(** In [set_interval ~every cb], call !{cb} every given seconds.*)
val set_interval : every:float -> (unit -> unit) -> Dom_html.interval_id

(** Call your function with the scope of JavaScript's this object,
    very useful *)
val with_this : (_ Js.t -> 'b) -> Js.Unsafe.any

(** Turn JavaScript string array into OCaml list of string *)
val to_string_list : Js.string_array Js.t -> string list

(** Turn OCaml list of strings into JavaScript string array *)
val of_string_list : string list -> Js.js_string Js.t Js.js_array Js.t

(** require for CommonJS environments *)
val require : string -> _ Js.t

(** Parse a string as JSON *)
val json_parse : string -> _ Js.t

(** Get all keys of an Object *)
val keys : Js.Unsafe.any -> string list

(** For each item in the object, call function and ignore results *)
val for_each_iter : f:('a -> 'b) -> Js.Unsafe.any -> unit

(** For each item in the object, call function and keep results *)
val for_each_map : f:(string -> 'a -> 'b) -> Js.Unsafe.any -> 'b list

(** Get the current UNIX time *)
val time_now : unit -> float
