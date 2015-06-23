define(['lodash', 'react', 'react-bootstrap', 'interop', 'events', 'ui',
        'Components/Chat', 'Components/MapPicker'],
function(_, React, ReactBootstrap, interop, events, ui,
         Chat, MapPicker) {

    var Panel = ReactBootstrap.Panel;
    var Button = ReactBootstrap.Button;
    var Well = ReactBootstrap.Well;
    var Popover = ReactBootstrap.Popover;
    var Table = ReactBootstrap.Table;
    var ListGroup = ReactBootstrap.ListGroup;
    var ListGroupItem = ReactBootstrap.ListGroupItem;
    var ModalTrigger = ReactBootstrap.ModalTrigger;
    
    var Div = ui.Div;
    var Gap = ui.Gap;
    var UiImage = ui.UiImage;
    var UiButton = ui.UiButton;
    var Dropdown = ui.Dropdown;
    var OptionList = ui.OptionList;
    var RenderAtMixin = ui.RenderAtMixin;
    
    var pos = ui.pos;
    var size = ui.size;
    var width = ui.width;
    var subImage = ui.subImage;

    var UnitBar = React.createClass({displayName: "UnitBar",
        mixins: [RenderAtMixin, events.UpdateMixin],

        item: function(p, image, scale, image_pos, data) {
            return (
                React.createElement(Div, {nonBlocking: true, pos: p}, 
                    React.createElement(UiImage, {nonBlocking: true, pos: image_pos, width: 4.2*scale, image: image}), 
                    React.createElement("p", {style: {paddingLeft:'5%', 'pointer-events': 'none'}}, 
                        data
                    )
                )
            );
        },
        
        renderAt: function() {
            var x = 2;
            var small = 13.2, big = 17.2;
            
            var Images = playerImages[this.props.MyPlayerNumber];
            var Buildings = Images.Buildings;
            var Units = Images.Units;
        
            return (
                React.createElement("div", null, 
                    React.createElement(Div, {nonBlocking: true, pos: pos(0,0.92)}, 
                        React.createElement(Div, {pos: pos(x-small,0)}, React.createElement("p", null, "Player ", this.props.MyPlayerNumber)), 
                        this.item(pos(x,0),        Buildings.Barracks, 1,    pos(0,0),     this.props.info.Barracks.Count), 
                        this.item(pos(x+=small,0), Units.Soldier,      0.85, pos(0.4,0),   this.props.info.Units), 
                        this.item(pos(x+=big,0),   Buildings.GoldMine, 1,    pos(0,0),     this.props.info.GoldMine.Count), 
                        this.item(pos(x+=small,0), GoldImage,          0.67, pos(1.2,0.5), this.props.info.Gold), 
                        this.item(pos(x+=big,0),   Buildings.JadeMine, 1,    pos(0,0),     this.props.info.JadeMine.Count), 
                        this.item(pos(x+=small,0), JadeImage,          0.67, pos(1.2,0.5), this.props.info.Jade)
                    )
                )
            );
        },
    });

    return React.createClass({
        mixins: [],

        show: function() {
            this.setState({
                show: true,
            });
        },

        getInitialState: function() {
            if (interop.InXna()) {
                setTimeout(this.show, 4500);

                return {
                    show: false,
                };
            } else {
                this.props.params = {"victory":true,"winningTeam":2,"info":[null,{"Name":"Player 1","Number":1,"GoldMine":{"Count":0,"Bought":0},"JadeMine":{"Count":0,"Bought":0},"Barracks":{"Count":100,"Bought":0},"Gold":7500,"Jade":10000,"Units":100,"DragonLords":1,"SpellCasts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"SpellCosts":{"Fireball":1000,"Skeletons":1000,"Necromancer":1000,"Terracotta":1000},"DragonLordAlive":true,"Params":{"Buildings":{"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"}},"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"},"StartGold":750,"StartJade":10000}},{"Name":"Player 2","Number":2,"GoldMine":{"Count":0,"Bought":0},"JadeMine":{"Count":0,"Bought":0},"Barracks":{"Count":187,"Bought":0},"Gold":7500,"Jade":10000,"Units":187,"DragonLords":2,"SpellCasts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"SpellCosts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"DragonLordAlive":true,"Params":{"Buildings":{"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"}},"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"},"StartGold":750,"StartJade":10000}},{"Name":"Player 3","Number":3,"GoldMine":{"Count":0,"Bought":0},"JadeMine":{"Count":0,"Bought":0},"Barracks":{"Count":0,"Bought":0},"Gold":7500,"Jade":10000,"Units":0,"DragonLords":0,"SpellCasts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"SpellCosts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"DragonLordAlive":false,"Params":{"Buildings":{"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"}},"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"},"StartGold":750,"StartJade":10000}},{"Name":"Player 4","Number":4,"GoldMine":{"Count":0,"Bought":0},"JadeMine":{"Count":0,"Bought":0},"Barracks":{"Count":0,"Bought":0},"Gold":7500,"Jade":10000,"Units":0,"DragonLords":0,"SpellCasts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"SpellCosts":{"Fireball":0,"Skeletons":0,"Necromancer":0,"Terracotta":0},"DragonLordAlive":false,"Params":{"Buildings":{"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"}},"Barracks":{"GoldCost":250,"CostIncrease":50,"GoldPerTick":0,"JadePerTick":0,"CurrentGoldCost":250,"UnitType":0.0235294122,"Name":"Barracks"},"GoldMine":{"GoldCost":500,"CostIncrease":100,"GoldPerTick":3,"JadePerTick":0,"CurrentGoldCost":500,"UnitType":0.02745098,"Name":"GoldMine"},"JadeMine":{"GoldCost":1000,"CostIncrease":200,"GoldPerTick":0,"JadePerTick":3,"CurrentGoldCost":1000,"UnitType":0.03137255,"Name":"JadeMine"},"StartGold":750,"StartJade":10000}}]};

                return {
                    show: true,
                };
            }
        },

        render: function() {
            var _this = this;

            if (!this.state.show) {
                return (
                    React.createElement("div", null
                    )
                );
            }

            var players = _.range(1,5);

            return (
                React.createElement("div", null, 
                    React.createElement(Div, {nonBlocking: true, pos: pos(10,10), size: width(80)}, 
                        React.createElement(Well, {style: {'height':'80%'}}, 
                            React.createElement("h1", {style: {float:'left'}}, 
                                this.props.params.victory ? 'Victory!' : 'Defeat!', 
                                " " + ' ' +
                                "Team ", this.props.params.winningTeam, " wins!"
                            ), 

                            /* Info */
                            React.createElement(Div, {pos: pos(-30,20)}, 
                                _.map(players, function(player, index) {
                                    return (
                                        React.createElement(UnitBar, {MyPlayerNumber: player, info: _this.props.params.info[player], 
                                                 pos: pos(50.5,0.4 + index*7), size: width(75)})
                                    );
                                })
                            ), 

                            /* Buttons */
                            React.createElement(Div, {nonBlocking: true, pos: pos(36,72), size: width(60)}, 
                                React.createElement("div", {style: {'float':'right', 'pointer-events':'auto'}}, 
                                    React.createElement("p", null, 
                                        React.createElement(Button, {onClick: leaveGame}, "Leave Game")
                                    )
                                )
                            )
                        )
                    )
                )
            );
        }
    });
}); 