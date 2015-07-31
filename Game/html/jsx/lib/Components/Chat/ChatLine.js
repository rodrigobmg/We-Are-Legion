define(['lodash', 'react', 'react-bootstrap', 'interop', 'events', 'ui'], function(_, React, ReactBootstrap, interop, events, ui) {
    var Input = ReactBootstrap.Input;
    
    var Div = ui.Div;
    var UiImage = ui.UiImage;
    var UiButton = ui.UiButton;
    var RenderAtMixin = ui.RenderAtMixin;
    
    var pos = ui.pos;
    var size = ui.size;
    var width = ui.width;
    var subImage = ui.subImage;

    return React.createClass({
        getDefaultProps: function() {
            return {
                willFadeOut:true,
                hasBackground:true,
            };
        },

        componentDidMount: function() {
            var self = this;
            
            //this.alpha = 0;
            //this.fadeIn();
            
            this.alpha = 1;

            if (this.props.willFadeOut) {
                setTimeout(function() {
                    self.fadeOut();
                }, 6200);
            }
        },
        
        fadeIn: function() {
            this.alpha += 0.05;
            if (this.alpha > 1) {
                this.alpha = 1;
            } else {
                setTimeout(this.fadeIn, 16);
            }
            
            if (this.isMounted()) {
                this.getDOMNode().style.opacity = this.alpha;
            }
        },

        fadeOut: function() {
            this.alpha -= 0.05;
            if (this.alpha < 0) {
                this.alpha = 0;
                this.props.remove(this.props.message);
            } else {
                if (this.isMounted()) {
                    this.getDOMNode().style.opacity = this.alpha;
                }

                setTimeout(this.fadeOut, 16);
            }
        },

        render: function() {
            var message = this.props.message;
            
            var className = 'chat-line';
            if (this.props.hasBackground) {
                className += ' chat-background';
            }

            return (
                <p className={className} style={{opacity:1}}>
                    <span style={{color:'rgba(180,180,255,255)'}}>{message.name}: </span>
                    <span>{message.message}</span>
                    <br />
                </p>
            );
        },
    });
});