/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Button } from 'react-native';
import { AdioManager, AdioManagerProvider } from './AdioManager';
import TestApp from './TestApp';

const audioUrl =
  'https://adio-clips-dev.s3.amazonaws.com/projects/62775440-a642-11e8-905c-073edd0e1352/clips/6c6f5c90-a642-11e8-8aff-45abddd89f45.wav';

const file = {
  id: 'test1',
  name: 'Test 1',
  src: audioUrl,
};

const file2 = {
  id: 'test2',
  name: 'Test 2',
  src: audioUrl,
};

export default class App extends Component {
  state = {
    testing: false,
  };

  render() {
    return (
      <View style={styles.container}>
        <Button
          onPress={() =>
            this.setState((state) => ({
              testing: !state.testing,
            }))
          }
          title={this.state.testing ? 'Stop Testing' : 'Start Testing'}
        />
        {this.state.testing && (
          <AdioManagerProvider>
            <TestApp />
          </AdioManagerProvider>
        )}
        {/* <AdioManagerProvider clips={[file]}>
          <AdioManager>
            {({ getState, addClips, play }) => {
              const state = getState();

              return (
                <View>
                  <Text>{state.audioSessionStatus || 'NOTHING'}</Text>
                  {state.clips.map((clip) => {
                    const isDownloading = state.downloadingClips[clip.id];

                    return (
                      <View key={clip.id}>
                        <Text>{clip.id}</Text>
                        <Text>
                          {clip.isDownloaded ? 'Downloaded' : 'Not Downloaded'}
                        </Text>
                        {!!isDownloading && (
                          <Text>{isDownloading.progress}</Text>
                        )}
                      </View>
                    );
                  })}

                  {state.audioSessionStatus && (
                    <Button
                      onPress={() => addClips([file])}
                      title="Add Clips"
                    />
                  )}

                  {state.audioSessionStatus && (
                    <Button onPress={play} title="Play" />
                  )}
                </View>
              );
            }}
          </AdioManager>
        </AdioManagerProvider> */}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
