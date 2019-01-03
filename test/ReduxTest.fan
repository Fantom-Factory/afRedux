using afIoc::RegistryBuilder
using afIoc::Scope
using afIoc::Contribute
using afIoc::Configuration

abstract internal class ReduxTest : Test {

	Scope? scope
	
	override Void setup() {
		scope = RegistryBuilder() { it.suppressLogging = true }
			.addModulesFromPod("afMorphia")
			.addModule(T_ReduxTestModule#)
			.onRegistryStartup |Configuration config| {
				config.remove("afIoc.logServices")
				config.remove("afIoc.logBanner")
				config.remove("afIoc.logStartupTimes")
			}
			.onRegistryShutdown |Configuration config| {
				config.remove("afIoc.sayGoodbye")
			}
			.build
			.rootScope
		scope.inject(this)
	}
	
	override Void teardown() {
		scope?.registry?.shutdown
	}
}

internal const class T_ReduxTestModule {
}
