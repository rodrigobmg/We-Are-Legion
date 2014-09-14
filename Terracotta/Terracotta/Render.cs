using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

using FragSharpHelper;
using FragSharpFramework;

namespace GpuSim
{
    [Flags]
    public enum Alignment
    {
        Center  = 0,
        
        LeftJusitfy = Left | Top,
        RightJusitfy = Right | Top, 

        Left    = 1 << 0,
        Right   = 1 << 1,
        Top     = 1 << 2,
        Bottom  = 1 << 3
    }

    public static class Render
    {
        static SpriteBatch MySpriteBatch;
        
        static SpriteFont Font1, Font2;

        public static void Initialize()
        {
            MySpriteBatch = new SpriteBatch(GameClass.Graphics);
            Font1 = GameClass.ContentManager.Load<SpriteFont>("Default");
            Font2 = GameClass.ContentManager.Load<SpriteFont>("Bauhaus");
        }

        public static void StandardRenderSetup()
        {
            GameClass.Graphics.RasterizerState = RasterizerState.CullNone;
            GameClass.Graphics.BlendState = BlendState.AlphaBlend;
            GameClass.Graphics.DepthStencilState = DepthStencilState.DepthRead;
        }

        public static void UnsetDevice()
        {
            for (int i = 0; i < 16; i++)
            {
                try
                {
                    GameClass.Graphics.Textures[i] = null;
                }
                catch
                { 
                    
                }
            }
            GameClass.Graphics.SetRenderTarget(null);
        }

        static bool TextStarted = false;
        public static void StartText()
        {
            if (TextStarted) return;

            TextStarted = true;
            MySpriteBatch.Begin();
        }

        public static void EndText()
        {
            if (!TextStarted) return;

            TextStarted = false;
            MySpriteBatch.End();
        }

        public static void DrawText(string text, vec2 pos, float scale, Alignment align = Alignment.LeftJusitfy)
        {
            DrawText(Font2, text, pos, scale, align, new color(1f, 1f, 1f, 1f));
        }

        public static void DrawText(string text, vec2 pos, float scale, color clr, Alignment align = Alignment.LeftJusitfy)
        {
            DrawText(Font2, text, pos, scale, align, clr);
        }

        public static void DrawText(SpriteFont font, string text, vec2 pos, float scale, Alignment align, color clr)
        {
            vec2 size = (vec2)font.MeasureString(text) * scale;
            vec2 origin = size * 0.5f;

            if (align.HasFlag(Alignment.Left))
                origin.x -= size.x / 2;

            if (align.HasFlag(Alignment.Right))
                origin.x += size.x / 2;

            if (align.HasFlag(Alignment.Top))
                origin.y -= size.y / 2;

            if (align.HasFlag(Alignment.Bottom))
                origin.y += size.y / 2;
            
            MySpriteBatch.DrawString(font, text, pos, (Color)clr.Premultiplied, 0, origin, scale, SpriteEffects.None, 0);
        }
    }
}
