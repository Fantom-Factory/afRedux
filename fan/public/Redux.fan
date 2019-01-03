using afIoc::Inject
using afIoc::Scope

** (Service) - 
** The main entry point into Redux.
const mixin Redux {

}

internal const class ReduxImpl : Redux {

	new make(|This| f) { f(this) }

}
