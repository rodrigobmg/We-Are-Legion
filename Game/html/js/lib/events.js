'use strict';

define(['lodash'], function (_) {
    var makeEventMixin = function makeEventMixin(triggerName, eventName) {
        var callbacks = [];

        window[triggerName] = function (json) {
            _.each(callbacks, function (item) {
                item[eventName](json);
            });
        };

        return {
            componentDidMount: function componentDidMount() {
                log('push something! ' + eventName);
                callbacks.push(this);
            },

            componentWillUnmount: function componentWillUnmount() {
                var _this = this;
                _.remove(callbacks, function (e) {
                    return e === _this;
                });
            }
        };
    };

    return {
        UpdateMixin: makeEventMixin('update', 'onUpdate'),
        UpdateEditorMixin: makeEventMixin('updateEditor', 'onUpdateEditor'),
        Command: makeEventMixin('command', 'onCommand'),
        LobbyMixin: makeEventMixin('lobby', 'onLobbyUpdate'),
        JoinFailedMixin: makeEventMixin('joinFailed', 'onJoinFailed'),
        LobbyMapMixin: makeEventMixin('lobbyMap', 'onLobbyMapUpdate'),
        OnChatMixin: makeEventMixin('addChatMessage', 'onChatMessage'),
        ShowUpdateMixin: makeEventMixin('show', 'onShowUpdate'),
        SetParamsMixin: makeEventMixin('setParams', 'onSetParams'),
        SetModeMixin: makeEventMixin('setMode', 'onSetMode'),
        FindLobbiesMixin: makeEventMixin('lobbies', 'onFindLobbies'),
        WinningTeamMixin: makeEventMixin('winningTeam', 'onWinningTeam'),

        AllowBackMixin: {
            componentDidMount: function componentDidMount() {
                window.onEscape = window.back;
                window.allowBack();
            },

            componentWillUnmount: function componentWillUnmount() {
                window.onEscape = null;
                window.preventBack();
            }
        }
    };
});