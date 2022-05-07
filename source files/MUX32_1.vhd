----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:45:26 04/11/2021 
-- Design Name: 
-- Module Name:    MUX1_32 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package mux_pack is
        type muxIn is array (0 to 31)of std_logic_vector(31 downto 0);
		  type muxIn5bits is array (0 to 31) of std_logic_vector(4 downto 0);
end package;


use work.mux_pack.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX32_1 is
    Port ( Min : in muxIn;
           Control : in STD_LOGIC_VECTOR (4 downto 0);
           Mout : out STD_LOGIC_VECTOR (31 downto 0));
           
end MUX32_1;

architecture Behavioral of MUX32_1 is

signal temp: std_logic_vector(31 downto 0);

begin



process(Min,Control,temp)
begin

temp<=std_logic_vector(Min(to_integer(unsigned(Control))));

end process;

Mout<=temp;


end Behavioral;
