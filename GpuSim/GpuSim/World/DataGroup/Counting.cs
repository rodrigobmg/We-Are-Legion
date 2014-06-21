using System;

using FragSharpFramework;

namespace GpuSim
{
    public partial class DataGroup : SimShader
    {
        public int[] UnitCount = new int[] { 0, 0, 0, 0, 0 };
        public int[] BarracksCount = new int[] { 0, 0, 0, 0, 0 };
        public int SelectedUnits = 0, SelectedBarracks = 0;

        public void DoGoldMineCount(PlayerInfo[] PlayerInfo)
        {
            CountGoldMines.Apply(CurrentData, CurrentUnits, Output: Multigrid[0]);

            var count = (PlayerTuple)MultigridReduce(CountReduce_4x1byte.Apply);

            PlayerInfo[1].GoldMines = Int(count.PlayerOne);
            PlayerInfo[2].GoldMines = Int(count.PlayerTwo);
            PlayerInfo[3].GoldMines = Int(count.PlayerThree);
            PlayerInfo[4].GoldMines = Int(count.PlayerFour);
        }

        public Tuple<int, int> DoUnitCount(float player, bool only_selected)
        {
            CountUnits.Apply(CurrentData, CurrentUnits, player, only_selected, Output: Multigrid[0]);

            color count = MultigridReduce(CountReduce_3byte1byte.Apply);

            int unit_count = (int)(SimShader.unpack_coord(count.xyz) + .5f);
            int barracks_count = Int(count.w);
            
            return new Tuple<int,int>(unit_count, barracks_count);
        }
    }
}
