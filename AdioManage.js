import { NativeModules, NativeEventEmitter } from 'react-native';

const NativeAdioManager = NativeModules.AdioManager;
const AdioManagerEvents = new NativeEventEmitter(NativeAdioManager);

export default class AdioManage {
  static manager = null;

  audioSessionCreated = false;

  static init() {
    if (AdioManage.manager) {
      AdioManage.manager;
    }

    AdioManage.manager = new AdioManage();

    return AdioManage.manager;
  }

  constructor() {
    NativeAdioManager.createAudioSession()
      .then(() => {
        this.audioSessionCreated = success;
      })
      .catch(console.warn);
  }

  async addClip(clip) {
    try {
      await NativeAdioManager.addClip(clip);
    } catch (e) {
      console.warn(e);
    }
  }

  async addClips(clips) {
    try {
      await NativeAdioManager.addClips(clips);
    } catch (e) {
      console.warn(e);
    }
  }
}
