
class Store {
	private	Obj?	rootState
	const	Reducer rootReducer
	
	StoreListener[]	listeners	:= StoreListener[,]
	
	new make(Obj? rootState, Reducer rootReducer) {
		this.rootState	 = rootState
		this.rootReducer = rootReducer
	}
	
	Obj? getState() {
		rootState
	}
	
	Void dispatch(Action action) {
		rootState = rootReducer.reduce(rootState, action).toImmutable
		listeners.each { it.actionDispatched(this, action) }
	}
	
	|->| subscribe(StoreListener listener) {
		listeners.add(listener)
		return |->| { listeners.remove(listener) }
	}
	
//	// have a time machine strategy, do we copy the root state obj, require reducers have a reverse func, or re-build / re-run the actions from the start?
//	// should these return the new state?
//	Void forward(Int numSteps) { }
//	Void backward(Int numSteps) { }
}


const mixin StoreListener {
	abstract Void actionDispatched(Store store, Action action)
}

// Thunk middleware allow action creators to return factory methods

// > Asynchronous middleware like redux-thunk or redux-promise wraps the store's dispatch() method and allows you to dispatch something other than actions, for example, functions or Promises.

// Middleware
