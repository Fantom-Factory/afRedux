
const class TodoExample {
	static Void main(Str[] args) {
		
		// try to keep this example as faithful to the orig as possible 
		
		reduce := | |Obj? state, Action action -> Obj?| fn -> Reducer| {
			FuncReducer(fn)
		}
		
		rootReducer := reduce |AppRootState state, action| {
			Reducer.clone(state, [
//				AppRootState#filter	: ReducerHelper.actionFieldValueReducer(SetVisibilityFilterAction#filter).reduce(state.filter, action),
				AppRootState#filter	: VisibilityReducer().reduce(state.todos, action),
				AppRootState#todos	: TodoReducer().reduce(state.todos, action)
			])
		}		
		
//		store := Store(AppRootState(), AppRootReducer())
		store := Store(AppRootState(), rootReducer)
		
		echo(store.getState)
		
		unsubscribe := store.subscribe(EchoListner())
		
		store.dispatch(AddTodoAction("Learn about actions"))
		store.dispatch(AddTodoAction("Learn about reducers"))
		store.dispatch(AddTodoAction("Learn about store"))
		store.dispatch(ToggleTodoAction(0))
		store.dispatch(ToggleTodoAction(1))
		store.dispatch(SetVisibilityFilterAction("showCompleted"))
		
		unsubscribe()
		
		echo(store.getState)
	}
}



// ---- State ----

const class AppRootState {
	const Str 		filter	:= "off"
	const Todo[]	todos	:= Todo[,]
	
	new make(|This|? f := null) { f?.call(this) }

	override Str toStr() { "${filter} - ${todos}" }
}

const class Todo {
	const Str		text
	const Bool		isComplete

	new make(|This| f) { f(this) }
	
	override Str toStr() { (isComplete ? "COMPLETE" : "TODO") + ": ${text}" }
}



// ---- Actions ----

const class AddTodoAction : Action {
	const Str text
	
	new make(Str text) {
		this.text = text
	}
}

const class ToggleTodoAction : Action {
	const Int todoId
	
	new make(Int todoId) {
		this.todoId = todoId
	}
}

const class SetVisibilityFilterAction : Action {
	const Str filter
	
	new make(Str filter) {
		this.filter = filter
	}
}



// ---- Reducers ----

const class AppRootReducer : Reducer {
	override Obj? reduce(Obj? state, Action action) {
		appState := (AppRootState) state
		return clone(appState, [
			AppRootState#filter	: VisibilityReducer().reduce(appState.filter, action),
			AppRootState#todos	: TodoReducer().reduce(appState.todos, action)
		])
		
//		appState := (AppRootState) state
//		return AppRootState {
//			it.filter = VisibilityReducer().reduce(appState.filter, action)
//			it.todos  = TodoReducer().reduce(appState.todos, action)
//		}
	}
}

const class VisibilityReducer : Reducer {
	override Obj? reduce(Obj? state, Action action) {
//		actionFieldValue(state, action, SetVisibilityFilterAction#filter)
		
		filter := (Str) state
		if (action is SetVisibilityFilterAction)
			filter = ((SetVisibilityFilterAction) action).filter
		return filter
	}
}

const class TodoReducer : Reducer {
	override Obj? reduce(Obj? state, Action action) {
		todos := (Todo[]) state

		if (action is AddTodoAction) {
			addTodoAction := (AddTodoAction) action
			newTodo := Todo {
				it.text 		= addTodoAction.text
				it.isComplete	= false
			}
//			return addToList(state, newTodo)
			todos = todos.rw
			todos.add(newTodo)
		}

		if (action is ToggleTodoAction) {
			toggleTodoAction := (ToggleTodoAction) action
			oldTodo := todos[toggleTodoAction.todoId]

//			newTodo := clone(oldTodo, [
//				Todo#isComplete	: !oldTodo.isComplete
//			])
//			return setListItem(state, toggleTodoAction.todoId, newTodo)
			
			newTodo := Todo {
				it.text 		= oldTodo.text
				it.isComplete	= !oldTodo.isComplete
			}
			todos = todos.rw
			todos[toggleTodoAction.todoId] = newTodo 
		}

		return todos
	}
}



// ---- Listeners ----

const class EchoListner : StoreListener {
	override Void actionDispatched(Store store, Action action) {
		echo("${action.typeof.name} -> ${store.getState}")
	}
}
