
const mixin Reducer {
	abstract Obj? reduce(Obj? state, Action action)
	
	static new fn(|Obj? state, Action action -> Obj?| fn) {
		FuncReducer(fn)
	}
	
	static Obj clone(Obj obj, Field:Obj? fieldVals) {
		cloneObj(obj) {
			it.setAll(fieldVals)
		}
	}
	
	private static Obj cloneObj(Obj obj, |Field:Obj|? overridePlan := null) {
		plan := Field:Obj[:]
		obj.typeof.fields.each |field| {
			if (field.isStatic) return
			value := field.get(obj)
			if (value != null)
				plan[field] = value
		}

		overridePlan?.call(plan)
		
		planFunc := Field.makeSetFunc(plan.map { it.toImmutable })
		return obj.typeof.method("make").call(planFunc)
	}
}

//const mixin ConstHelpers {
	
//	Obj copyFields(Obj obj, Field:Obj? fieldVals)
	
//	Obj[] addToList(Obj[] list, Obj item)
//	Obj[] replaceListItem(Obj[] list, Int idx, Obj item)
//	Obj[] removeFromList(Obj[] list, Obj item)
//	Obj[] removeAtFromList(Obj[] list, Int idx)

//	Obj:Obj addToMap(Obj:Obj list, Int idx)
//	Obj:Obj setInMap(Obj:Obj list, Int idx)
//	Obj:Obj removeFromMap(Obj:Obj list, Int idx)
	
	
//}

const class FuncReducer : Reducer {
	private const |Obj? state, Action action -> Obj?| fn
	
	new make(|Obj? state, Action action -> Obj?| fn) {
		this.fn = fn
	}
	
	override Obj? reduce(Obj? state, Action action) {
		this.fn(state, action).toImmutable
	}
}

//abstract class ReducerBuilder {
//	
//	private Reducer[] reducers := Reducer[,]
//	
//	@Operator
//	This add(Reducer reducer) {
//		reducers.add(reducer)
//		return this
//	}
//	
//	Reducer toReducer() {
//		reducers := reducers.toImmutable
//		return FuncReducer |Obj? state, Action action -> Obj?| {
//			reducers.each { it.reduce(state, action) }
//		}
//	}
//}

//mixin ReducerHelper {
//	
//	static Reducer reduceFn(|Obj? state, Action action -> Obj?| fn) {
//		FuncReducer(fn)
//	}
//
//	static Reducer actionFieldValueReducer(Field field) {
//		reduceFn |Obj? state, Action action -> Obj?| {
//			actionFieldValue(state, action, field)
//		}
//	}
//	
//	static Obj clone(Obj obj, Field:Obj? fieldVals) {
//		cloneObj(obj) {
//			it.setAll(fieldVals)
//		}
//	}
//	
//	static Obj? actionFieldValue(Obj? state, Action action, Field field) {
//		field.parent.fits(action.typeof) ? field.get(action) : state
//	}
//	
//	static List addToList(List list, Obj? item) {
//		list.rw.add(item).toImmutable
//	}
//	
//	static List setListItem(List list, Int idx, Obj? item) {
//		list.rw[idx] = item.toImmutable		
//	}
//	
//	private static Obj cloneObj(Obj obj, |Field:Obj|? overridePlan := null) {
//		plan := Field:Obj[:]
//		obj.typeof.fields.each {
//			value := it.get(obj)
//			if (value != null)
//				plan[it] = value
//		}
//
//		overridePlan?.call(plan)
//		
//		planFunc := Field.makeSetFunc(plan.map { it.toImmutable })
//		return obj.typeof.method("make").call(planFunc)
//	}
//}
