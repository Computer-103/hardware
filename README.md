# 103 计算机 现代硬件电路源码

```
.
├── README.md           # 说明文档
├── core                # 内核部分电路
│   ├── core_top.v          # 内核部分顶层模块
│   ├── arith_unit.v        # 运算器 АУ
│   ├── arith_ctrl.v        # 局部程序发送器 МПД
│   ├── operator.v          # 操作器 БО
│   ├── start_reg.v         # 启动寄存器 ПР
│   ├── select_reg.v        # 选择寄存器 СР
│   ├── pulse_unit.v        # 脉冲分配器 РИ
│   ├── memory.v            # 存贮器 ЗУ & МП
│   └── io_unit.v           # 输入输出电子部件 ЭУВВ
├── shell               # 外壳部分电路
│   ├── shell_top.v         # 外壳部分顶层模块
│   ├── driver_74lv165.v    # 74LV165 串行输入驱动模块
│   ├── driver_74lv595.v    # 74LV595 串行输出驱动模块
│   ├── button_pulse.v      # 按钮-脉冲信号
│   └── switch_level.v      # 开关-电平信号
├── include             # 涉及的外部模块
└── docs                # 文档
```