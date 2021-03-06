'use strict';

define(['lodash', 'react', 'react-bootstrap', 'interop', 'events', 'ui', 'Components/Chat'], function (_, React, ReactBootstrap, interop, events, ui, Chat) {
    var Panel = ReactBootstrap.Panel;
    var Button = ReactBootstrap.Button;
    var Well = ReactBootstrap.Well;
    var Nav = ReactBootstrap.Nav;
    var Popover = ReactBootstrap.Popover;
    var Table = ReactBootstrap.Table;

    var Div = ui.Div;
    var Gap = ui.Gap;
    var UiImage = ui.UiImage;
    var UiButton = ui.UiButton;
    var Dropdown = ui.Dropdown;
    var RenderAtMixin = ui.RenderAtMixin;
    var MenuItem = ui.MenuItem;
    var Menu = ui.Menu;

    var pos = ui.pos;
    var size = ui.size;
    var width = ui.width;
    var subImage = ui.subImage;

    return React.createClass({
        mixins: [],

        getInitialState: function getInitialState() {
            return {};
        },

        render: function render() {
            return React.createElement(
                Menu,
                null,
                React.createElement(
                    MenuItem,
                    { eventKey: 1, to: 'create-game' },
                    'Create game'
                ),
                React.createElement(
                    MenuItem,
                    { eventKey: 2, to: 'find-game' },
                    'Find game'
                ),
                React.createElement(
                    MenuItem,
                    { eventKey: 2, onClick: interop.startEditor },
                    'Map Editor'
                ),
                React.createElement(
                    MenuItem,
                    { eventKey: 4, to: 'options' },
                    'Options'
                ),
                React.createElement(
                    MenuItem,
                    { eventKey: 5, to: 'manual' },
                    'Manual'
                ),
                React.createElement(
                    MenuItem,
                    { eventKey: 6, onClick: quitApp },
                    'Quit Game'
                )
            );
        }
    });
});