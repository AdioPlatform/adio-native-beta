import React from 'react';
import { Text, View, Button } from 'react-native';
import { AdioManager } from './AdioManager';
import { clips } from './data';

console.log(clips);

const audioUrl =
  'https://adio-clips-dev.s3.amazonaws.com/projects/62775440-a642-11e8-905c-073edd0e1352/clips/6c6f5c90-a642-11e8-8aff-45abddd89f45.wav';

const file = {
  id: 'test1',
  name: 'Test 1',
  src: audioUrl,
  startTimeMs: 0,
};

const file2 = {
  id: 'test2',
  name: 'Test 2',
  src: audioUrl,
  startTimeMs: 1000,
};

const TestApp = () => {
  return (
    <AdioManager>
      {({
        play,
        stop,
        addClips,
        getState,
        isDownloadingClips,
        setSeekTime,
      }) => {
        const state = getState();

        const status = state.audioSessionStatus;
        const downloadingClips = isDownloadingClips();

        let playButtonProps = {};

        switch (downloadingClips ? '' : status) {
          case 'Playing':
            playButtonProps = {
              title: 'Stop',
              onPress: stop,
            };

            break;

          case 'Created':
          case 'Ready':
            playButtonProps = {
              title: 'Play',
              onPress: play,
            };

            break;

          default:
            playButtonProps = {
              title: 'IDK',
              onPress: () => {},
              disabled: true,
            };
        }

        return (
          <View>
            {isDownloadingClips() && (
              <View>
                {Object.keys(state.downloadingClips).map((id) => {
                  const download = state.downloadingClips[id];

                  return (
                    <View key={id}>
                      <Text>
                        {id} - {download.progress.toFixed(2)}
                      </Text>
                    </View>
                  );
                })}
              </View>
            )}
            <Button
              title="AddClips"
              onPress={() => {
                if (!status) return;

                // addClips([file, file2]);
                addClips(clips);
              }}
            />
            <Button {...playButtonProps} />
            <Button onPress={() => setSeekTime(3)} title="Start Over" />
            <Text>{state.time}</Text>
          </View>
        );
      }}
    </AdioManager>
  );
};

export default TestApp;
