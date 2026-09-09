{{flutter_js}}
{{flutter_build_config}}

const loading = window.flutterForgeLoading;
loading?.mark('loading-script', '正在加载 Flutter 资源…');

async function unregisterLegacyServiceWorkers() {
  if (!('serviceWorker' in navigator)) return false;
  const registrations = await navigator.serviceWorker.getRegistrations();
  await Promise.all(registrations.map((registration) => registration.unregister()));
  return navigator.serviceWorker.controller !== null;
}

(async () => {
  try {
    const wasControlled = await unregisterLegacyServiceWorkers();
    const reloadKey = 'flutter-forge-service-worker-cleanup';
    if (wasControlled && sessionStorage.getItem(reloadKey) !== 'done') {
      sessionStorage.setItem(reloadKey, 'done');
      location.reload();
      return;
    }
    sessionStorage.removeItem(reloadKey);

    _flutter.loader.load({
      onEntrypointLoaded: async (engineInitializer) => {
        try {
          loading?.mark('initializing-engine', '正在初始化渲染引擎…');
          const appRunner = await engineInitializer.initializeEngine();
          loading?.mark('running-app', '正在启动学习目录…');
          await appRunner.runApp();
          loading?.complete();
        } catch (error) {
          loading?.fail(error);
        }
      },
    });
  } catch (error) {
    loading?.fail(error);
  }
})();
