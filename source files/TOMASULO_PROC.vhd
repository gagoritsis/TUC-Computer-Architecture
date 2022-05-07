----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:46 04/25/2021 
-- Design Name: 
-- Module Name:    TOMASULO_PROC - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOMASULO_PROC is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           Issue : in  STD_LOGIC;
           FU_type : in  STD_LOGIC_VECTOR (1 downto 0);
           Fop : in  STD_LOGIC_VECTOR (1 downto 0);
           Ri : in  STD_LOGIC_VECTOR (4 downto 0);
           Rj : in  STD_LOGIC_VECTOR (4 downto 0);
           Rk : in  STD_LOGIC_VECTOR (4 downto 0);
           Accepted : out  STD_LOGIC);
end TOMASULO_PROC;

architecture Behavioral of TOMASULO_PROC is
component ISSUE_UNIT is
    Port ( CLK : in  STD_LOGIC;
			 -- RST : in STD_LOGIC;
			  Issue : in  STD_LOGIC;
           FU_type : in  STD_LOGIC_VECTOR (1 downto 0);
           Fop : in  STD_LOGIC_VECTOR (1 downto 0);
           Ri : in  STD_LOGIC_VECTOR (4 downto 0);
           Rj : in  STD_LOGIC_VECTOR (4 downto 0);
           Rk : in  STD_LOGIC_VECTOR (4 downto 0);
			  RS_Logic_Avail : in STD_LOGIC_VECTOR(1 downto 0); --00 not avail, 01 RS1 avail, 10 RS2 avail, 11 all avail
			  RS_Arith_Avail :in STD_LOGIC_VECTOR(2 downto 0); --000 not avail, 001 RS1 av, 010 RS2 av, 011 RS1 &RS2 av, 100 RS3 av, 101 RS1 & RS3 av, 110 RS3 & RS2 av, 111 all av
			  Ri_out : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
           Rj_out : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
           Rk_out : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
			  RS_tag : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
			  Op_to_RS : out STD_LOGIC_VECTOR (1 downto 0); --to RS
			  Issue_Logic : out STD_LOGIC; --to RS_FU_CTRL
			  Issue_Arith : out STD_LOGIC; --to RS_FU_CTRL
           Accepted : out  STD_LOGIC);
end component;

component RF is
	   Port ( CLK : in STD_LOGIC;
				RST : in STD_LOGIC;
				WrEn: in STD_LOGIC;
				CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			   CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
				RS_tag : in STD_LOGIC_VECTOR (4 downto 0); --in which RS the instruction is issued
				Ri : in  STD_LOGIC_VECTOR (4 downto 0);
				Rj : in  STD_LOGIC_VECTOR (4 downto 0);
				Rk : in  STD_LOGIC_VECTOR (4 downto 0);
			   Qjout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vjout : out  STD_LOGIC_VECTOR (31 downto 0);
				Qkout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vkout : out  STD_LOGIC_VECTOR (31 downto 0)
				);
end component;

component FU_1 is
    Port ( CLK : in STD_LOGIC;
			  RST	: in STD_LOGIC;
			  WriteEnable: in STD_LOGIC;
			  Op : in  STD_LOGIC_VECTOR (1 downto 0);
			  CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			  CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
           Vj : in  STD_LOGIC_VECTOR (31 downto 0);
           Vk : in  STD_LOGIC_VECTOR (31 downto 0);
			  Qj : in  STD_LOGIC_VECTOR (4 downto 0);
			  Qk : in  STD_LOGIC_VECTOR (4 downto 0);
			  mux_rs_control : in  STD_LOGIC_VECTOR (1 downto 0); --common control for Vj, Vk and Op
			  Issue : in  STD_LOGIC_VECTOR (2 downto 0); 
			  Accepted : in  STD_LOGIC_VECTOR (2 downto 0); 
			  FU_start : in STD_LOGIC;
			  RS_tag : in STD_LOGIC_VECTOR (4 downto 0);
			  Busy : out STD_LOGIC_VECTOR (2 downto 0);
			  Avail_to_Issue : out STD_LOGIC_VECTOR (2 downto 0);
			  Ready : out STD_LOGIC_VECTOR (2 downto 0);
			  Available : out STD_LOGIC_VECTOR (2 downto 0);
			  CDB_Qout : out STD_LOGIC_VECTOR (4 downto 0);
			  CDB_Vout : out STD_LOGIC_VECTOR (31 downto 0);
           AU_busy : out STD_LOGIC;
			  AU_result_ready : out  STD_LOGIC);
end component;

component FU_2 is
    Port ( CLK : in STD_LOGIC;
			  RST	: in STD_LOGIC;
			  WriteEnable: in STD_LOGIC;
			  Op : in  STD_LOGIC_VECTOR (1 downto 0);
			  CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			  CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
           Vj : in  STD_LOGIC_VECTOR (31 downto 0);
           Vk : in  STD_LOGIC_VECTOR (31 downto 0);
			  Qj : in  STD_LOGIC_VECTOR (4 downto 0);
			  Qk : in  STD_LOGIC_VECTOR (4 downto 0);
			  mux_rs_control : in  STD_LOGIC_VECTOR (1 downto 0); --common control for Vj, Vk and Op
			  Issue : in  STD_LOGIC_VECTOR (1 downto 0); 
			  Accepted : in  STD_LOGIC_VECTOR (1 downto 0); 
			  FU_start : in STD_LOGIC;
			  RS_tag : in STD_LOGIC_VECTOR (4 downto 0);
			  Busy : out STD_LOGIC_VECTOR (1 downto 0);
			  Avail_to_Issue : out STD_LOGIC_VECTOR (1 downto 0);
			  Ready : out STD_LOGIC_VECTOR (1 downto 0);
			  Available : out STD_LOGIC_VECTOR (1 downto 0);
			  CDB_Qout : out STD_LOGIC_VECTOR (4 downto 0);
			  CDB_Vout : out STD_LOGIC_VECTOR (31 downto 0);
           LU_busy : out STD_LOGIC;
			  LU_result_ready : out  STD_LOGIC);
end component;

component CDB is
    Port ( CLK : in STD_LOGIC;
			  RST : in STD_LOGIC;
			  FU1_Qin : in  STD_LOGIC_VECTOR (4 downto 0);
           FU1_Vin : in  STD_LOGIC_VECTOR (31 downto 0);
           FU2_Qin : in  STD_LOGIC_VECTOR (4 downto 0);
           FU2_Vin : in  STD_LOGIC_VECTOR (31 downto 0);
           FU3_Qin : in  STD_LOGIC_VECTOR (4 downto 0);
           FU3_Vin : in  STD_LOGIC_VECTOR (31 downto 0);
			  FU1_Req : in STD_LOGIC;
			  FU2_Req : in STD_LOGIC;
			  FU3_Req : in STD_LOGIC;
			  FU1_Grant : out STD_LOGIC;
			  FU2_Grant : out STD_LOGIC;
			  FU3_Grant : out STD_LOGIC;
           CDB_Q : out  STD_LOGIC_VECTOR (4 downto 0);
           CDB_V : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component CTRL_RS_FU is
    Port ( CLK : in STD_LOGIC;
			  RST	: in STD_LOGIC;
			  --FU1 to control
           Busy_RS_FU1 : in  STD_LOGIC_VECTOR(2 downto 0); --arithmetic FU
           Ready_RS_FU1 : in  STD_LOGIC_VECTOR(2 downto 0); --arithmetic FU
           RS_Arith_Avail : in  STD_LOGIC_VECTOR(2 downto 0); --arithmetic FU --mipws na mpainei apeutheias sto Issue unit?
			  FU1_result_ready : in STD_LOGIC;
			  FU1_busy : in STD_LOGIC;
			  --FU2 to control
           Busy_RS_FU2 : in  STD_LOGIC_VECTOR(1 downto 0); --logical FU
           Ready_RS_FU2 : in  STD_LOGIC_VECTOR(1 downto 0); --logical FU
           RS_Logic_Avail : in  STD_LOGIC_VECTOR(1 downto 0); --logical FU --mipws na mpainei apeutheias sto Issue unit?
			  FU2_result_ready : in STD_LOGIC;
  			  FU2_busy : in STD_LOGIC;
			  --CDB to control
			  FU1_Grant : in STD_LOGIC;			  
			  FU2_Grant : in STD_LOGIC;
			  FU3_Grant : in STD_LOGIC; --for 3rd FU --does not exist in this project
			  --Issue Unit to control
			  Issue_Logic : in STD_LOGIC; 
			  Issue_Arith : in STD_LOGIC; 
			  --control to FU1
           mux_rs_ctrl1 : out  STD_LOGIC_VECTOR(1 downto 0);
			  issue_at_fu1 : out STD_LOGIC_VECTOR(2 downto 0);
			  accepted_by_fu1 : out STD_LOGIC_VECTOR(2 downto 0);
			  wren_fu1 : out STD_LOGIC;
			  fu1_start : out STD_LOGIC;
			  --control to FU2
			  issue_at_fu2 : out STD_LOGIC_VECTOR(1 downto 0);
			  accepted_by_fu2 : out STD_LOGIC_VECTOR(1 downto 0);
			  wren_fu2 : out STD_LOGIC;
			  fu2_start : out STD_LOGIC;
			  mux_rs_ctrl2 : out  STD_LOGIC_VECTOR(1 downto 0);
			  --control to CDB
			  FU1_Req : out STD_LOGIC;			  
			  FU2_Req : out STD_LOGIC;
			  FU3_Req : out STD_LOGIC --for 3rd FU --does not exist in this project
			  );
end component;

signal issue_log,issue_ar : std_logic;
signal t_rs_log_av : std_logic_vector(1 downto 0);
signal t_rs_ar_av : std_logic_vector(2 downto 0);
signal rd,rs1,rs2 : std_logic_vector(4 downto 0);
signal tag : std_logic_vector(4 downto 0);
signal  t_mux_rs_ctrl1,t_mux_rs_ctrl2 : std_logic_vector(1 downto 0);
signal  t_issue_at_fu1,t_accepted_by_fu1,t_busy_rs_1,t_ready_rs_1,ar_avail_to_issue: std_logic_vector(2 downto 0);
signal  t_issue_at_fu2,t_accepted_by_fu2,t_op_to_rs,t_busy_rs_2,t_ready_rs_2,lu_avail_to_issue  : std_logic_vector(1 downto 0);
signal  t_wren_fu1,t_fu1_start,t_wren_fu2,t_fu2_start,t_FU1_Req,t_FU2_Req,t_FU3_Req: std_logic;
signal  t_lu_result_ready,t_lu_busy,t_au_result_ready,t_au_busy : std_logic;

signal tempout_Q,fu1_q,fu2_q,rf_qj,rf_qk : std_logic_vector (4 downto 0);
signal tempout_V,fu1_v,fu2_v,rf_vj,rf_vk : std_logic_vector (31 downto 0);
signal temp_grant1,temp_grant2,temp_grant3,temp_wren_rf : std_logic;

begin
issue_un:
	ISSUE_UNIT port map(CLK=>CLK,
							  Issue=>Issue,
							  FU_type=>FU_type,
							  Fop=>Fop,
							  Ri=>Ri,
							  Rj=>Rj,
							  Rk=>Rk,
							  RS_Logic_Avail=>lu_avail_to_issue,
							  RS_Arith_Avail=>ar_avail_to_issue,
							  Ri_out=>rd,
							  Rj_out=>rs1,
							  Rk_out=>rs2,
							  RS_tag=>tag,
							  Op_to_RS=>t_op_to_rs,
							  Issue_Logic=>issue_log,
							  Issue_Arith=>issue_ar,
							  Accepted=>Accepted);
register_file:
	RF port map(CLK=>CLK,
				RST=>RST,
				WrEn=>(issue_log or issue_ar),
				CDB_Q=>tempout_Q, 
			   CDB_V=>tempout_V,
				RS_tag=>tag,
				Ri=>ri,
				Rj=>rj,
				Rk=>rk,
			   Qjout=>rf_qj, 
			   Vjout=>rf_vj, 
				Qkout=>rf_qk,
			   Vkout=>rf_vk);

				
control_fu_rs:
	CTRL_RS_FU port map(CLK=>CLK,
			  RST=>RST,
			  --FU1 to control
           Busy_RS_FU1=>t_busy_rs_1,
           Ready_RS_FU1=>t_ready_rs_1,
           RS_Arith_Avail=>t_rs_ar_av,
			  FU1_result_ready=>t_au_result_ready,
			  FU1_busy=>t_au_busy,
			  --FU2 to control
           Busy_RS_FU2=>t_busy_rs_2,
           Ready_RS_FU2=>t_ready_rs_2,
           RS_Logic_Avail=>t_rs_log_av,
			  FU2_result_ready=>t_lu_result_ready,
  			  FU2_busy=>t_lu_busy, 
			  --CDB to control
			  FU1_Grant=>temp_grant1,			  
			  FU2_Grant=>temp_grant2,
			  FU3_Grant=>temp_grant3,
			  --Issue Unit to control
			  Issue_Logic=>issue_log, 
			  Issue_Arith=>issue_ar,
			  --control to FU1
           mux_rs_ctrl1=>t_mux_rs_ctrl1,
			  issue_at_fu1=>t_issue_at_fu1,
			  accepted_by_fu1=>t_accepted_by_fu1,
			  wren_fu1=>t_wren_fu1,
			  fu1_start=>t_fu1_start,
			  --control to FU2
			  issue_at_fu2=>t_issue_at_fu2,
			  accepted_by_fu2=>t_accepted_by_fu2,
			  wren_fu2=>t_wren_fu2,
			  fu2_start=>t_fu2_start,
			  mux_rs_ctrl2=>t_mux_rs_ctrl2,
			  --control to CDB
			  FU1_Req=>t_FU1_Req,			  
			  FU2_Req=>t_FU2_Req,
			  FU3_Req=>t_FU3_Req);
fu_arith:
	FU_1 port map(CLK=>CLK,
					  RST=>RST,
					  WriteEnable=>t_wren_fu1,
					  Op=>t_op_to_rs,
					  CDB_Q=>tempout_Q,
					  CDB_V=>tempout_V,
					  Vj=>rf_vj,
					  Vk=>rf_vk,
					  Qj=>rf_qj,
					  Qk=>rf_qk,
					  mux_rs_control=>t_mux_rs_ctrl1,
					  Issue=>t_issue_at_fu1,
					  Accepted=>t_accepted_by_fu1,
					  FU_start=>t_fu1_start,
					  RS_tag=>tag,
					  Busy=>t_busy_rs_1,
					  Avail_to_Issue=>ar_avail_to_issue,
					  Ready=>t_ready_rs_1,
					  Available=>t_rs_ar_av,
					  CDB_Qout=>fu1_q,
					  CDB_Vout=>fu1_v,
					  AU_busy=>t_au_busy,
					  AU_result_ready=>t_au_result_ready);
	
fu_logic:
	FU_2 port map(CLK=>CLK,
					  RST=>RST,
					  WriteEnable=>t_wren_fu2,
					  Op=>t_op_to_rs,
					  CDB_Q=>tempout_Q,
					  CDB_V=>tempout_V,
					  Vj=>rf_vj,
					  Vk=>rf_vk,
					  Qj=>rf_qj,
					  Qk=>rf_qk,
					  mux_rs_control=>t_mux_rs_ctrl2,
					  Issue=>t_issue_at_fu2,
					  Accepted=>t_accepted_by_fu2,
					  FU_start=>t_fu2_start,
					  RS_tag=>tag,
					  Busy=>t_busy_rs_2,
					  Avail_to_Issue=>lu_avail_to_issue,
					  Ready=>t_ready_rs_2,
					  Available=>t_rs_log_av,
					  CDB_Qout=>fu2_q,
					  CDB_Vout=>fu2_v,
					  LU_busy=>t_lu_busy,
					  LU_result_ready=>t_lu_result_ready);
					  
common_data_bus:
	CDB port map(CLK=>CLK,
				  RST=>RST,
				  FU1_Qin=>fu1_q,
				  FU1_Vin=>fu1_v,
				  FU2_Qin=>fu2_q,
				  FU2_Vin=>fu2_v,
				  FU3_Qin=>"00000",
				  FU3_Vin=>x"00000000",
				  FU1_Req=>t_FU1_Req,
				  FU2_Req=>t_FU2_Req,
				  FU3_Req=>t_FU3_Req,
				  FU1_Grant=>temp_grant1,
				  FU2_Grant=>temp_grant2,
				  FU3_Grant=>temp_grant3,
				  CDB_Q=>tempout_Q,
				  CDB_V=>tempout_V);
end Behavioral;

