import React, { Component, createContext } from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';

const NativeAdioManager = NativeModules.AdioManager;
const AdioManagerEvents = new NativeEventEmitter(NativeAdioManager);

const { Consumer: AdioManager, Provider } = createContext();

export { AdioManager };

const updateClip = (clip) => (state) => {
  const clipIndex = state.clips.findIndex(({ id }) => {
    return id === clip.id;
  });

  const clips = [
    ...state.clips.slice(0, clipIndex),
    clip,
    ...state.clips.slice(clipIndex + 1, state.clips.length),
  ];

  return { clips };
};

export class AdioManagerProvider extends Component {
  state = {
    clips: [],
    downloadingClips: {},
  };

  constructor(props) {
    super(props);

    this.providerValue = {
      getState: this.getState,
      downloadClip: this.downloadClip,
      downloadAllClips: this.downloadAllClips,
    };

    if (this.props.clips.length) {
      this.addClips(this.props.clips);
    }
  }

  componentDidMount() {
    AdioManagerEvents.addListener(
      'clipDownloadProgress',
      this.onClipDownloadProgress,
    );

    AdioManagerEvents.addListener('clipDownloaded', this.onClipDownload);
  }

  componentWillUnmount() {
    AdioManagerEvents.removeListener(
      'clipDownloadProgress',
      this.onClipDownloadProgress,
    );
  }

  getState = () => {
    return this.state;
  };

  addClips = async (clips = []) => {
    const addedClips = await NativeAdioManager.addClips(clips);

    this.setState((state) => {
      return {
        clips: [...state.clips, ...addedClips],
      };
    });
  };

  onClipDownload = (clip) => {
    this.setState(updateClip(clip));
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

  downloadClip = (id) => {
    NativeAdioManager.downloadClip(id);
  };

  downloadAllClips = () => {
    NativeAdioManager.downloadAllClips();
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
