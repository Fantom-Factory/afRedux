using concurrent::ActorPool
using afConcurrent::SynchronizedList
using afConcurrent::SynchronizedState

const class Store {
	private	const SynchronizedState	rootStateRef
	private	const SynchronizedList	listenerRefs
	
	const	Reducer rootReducer
	
	new make(Obj? rootState, Reducer rootReducer) {
		reduxActorPool := ActorPool()
		this.rootStateRef = SynchronizedState(reduxActorPool) |->Obj| { [rootState] }
		this.listenerRefs = SynchronizedList (reduxActorPool)
		this.rootReducer  = rootReducer
	}
	
	Obj? getState() {
		rootStateRef.sync |Obj[] stateRef->Obj| { stateRef.first }
	}
	
	Void dispatch(Action action) {
		rootStateRef.sync |Obj[] stateRef| {
			rootState := stateRef.first
			rootState = rootReducer.reduce(rootState, action).toImmutable
			stateRef.clear.add(rootState)
		}
		listenerRefs.each |StoreListener sl| { sl.actionDispatched(this, action) }
	}
	
	|->| subscribe(StoreListener listener) {
		// TODO have sync and async listeners
		listenerRefs.add(listener)
		return |->| { listenerRefs.remove(listener) }
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
