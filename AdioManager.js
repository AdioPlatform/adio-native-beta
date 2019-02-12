import React, { Component, createContext } from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';

const NativeAdioManager = NativeModules.AdioManager;
const AdioManagerEvents = new NativeEventEmitter(NativeAdioManager);

const { Consumer: AdioManager, Provider } = createContext();

export { AdioManager };

export const withAudioManager = (Comp) => (
  <AdioManager>{(props) => <Comp {...props} />}</AdioManager>
);

export class AdioManagerProvider extends Component {
  state = {
    downloadingClips: {},
    audioSessionStatus: null,
    time: 0,
  };

  constructor(props) {
    super(props);

    this.providerValue = {
      getState: this.getState,
      play: this.play,
      stop: this.stop,
      createAudioSession: this.createAudioSession,
      addClip: this.addClip,
      addClips: this.addClips,
      isDownloadingClips: this.isDownloadingClips,
      setSeekTime: this.setTime,
    };
  }

  componentDidMount() {
    AdioManagerEvents.addListener(
      'clipDownloadProgress',
      this.onClipDownloadProgress,
    );
    AdioManagerEvents.addListener('clipDownloaded', this.onClipDownload);
    AdioManagerEvents.addListener(
      'audioSessionStatusUpdated',
      this.audioSessionStatusUpdated,
    );

    AdioManagerEvents.addListener('timeUpdated', this.timeUpdated);

    this.createAudioSession();
  }

  componentWillUnmount() {
    this.destroyAudioSession();

    AdioManagerEvents.removeListener(
      'clipDownloadProgress',
      this.onClipDownloadProgress,
    );

    AdioManagerEvents.removeListener('clipDownloaded', this.onClipDownload);
    AdioManagerEvents.removeListener(
      'audioSessionStatusUpdated',
      this.audioSessionStatusUpdated,
    );

    AdioManagerEvents.removeListener('timeUpdated', this.timeUpdated);
  }

  timeUpdated = (time) => {
    this.setState({ time });
  };

  audioSessionStatusUpdated = (audioSessionStatus) => {
    this.setState(() => ({
      audioSessionStatus,
    }));
  };

  setTime = (time) => {
    NativeAdioManager.setSeekTime(time);
  };

  getState = () => {
    return this.state;
  };

  addClips = async (clips = []) => {
    return await NativeAdioManager.addClips(clips);
  };

  addClip = async (clip) => {
    return await NativeAdioManager.addClip(clip);
  };

  isDownloadingClips = () => {
    return Object.keys(this.state.downloadingClips).length > 0;
  };

  onClipDownload = (clip) => {
    this.setState((state) => {
      const { downloadingClips } = state;

      return {
        downloadingClips: Object.keys(downloadingClips).reduce(
          (newDownloadingClips, clipId) => {
            if (clip.id === clipId) return newDownloadingClips;

            return {
              [clipId]: downloadingClips[clipId],
            };
          },
          {},
        ),
      };
    });
  };

  onClipDownloadProgress = (clipDownloadProgress) => {
    this.setState((state) => {
      return {
        downloadingClips: {
          ...state.downloadingClips,
          [clipDownloadProgress.id]: clipDownloadProgress,
        },
      };
    });
  };

  createAudioSession = async () => {
    return await NativeAdioManager.createAudioSession();
  };

  destroyAudioSession = async () => {
    return await NativeAdioManager.destroyAudioSession();
  };

  play = () => {
    NativeAdioManager.play();
  };

  stop = () => {
    NativeAdioManager.stop();
  };

  render() {
    const providerValue = this.providerValue;

    return (
      <Provider value={{ ...providerValue, getState: this.getState }}>
        {this.props.children}
      </Provider>
    );
  }
}
