import React from 'react';
import AdioManage from './AdioManage';

export const withAudioManager = (Comp) => {
  return class extends React.Component {
    constructor(props) {
      super(props);

      AdioManage.init();
    }

    render() {
      return <Comp {...this.props} manager={AdioManage.manager} />;
    }
  };
};
