#ifndef AST_HPP
#define AST_HPP

#include <vector>

#include "cmn.hpp"

namespace AST {
	class Root {
	public:
		std::vector <Unit*> unit_list;
	};  // AST的根结点
	class Unit {
	public:
		u32 line;
		u32 column;
	};  // AST的每个编译单元，包括一个全局变量的声明，函数的定义（sysY不用实现函数的声明）
	class VarDec : public Unit {
		std::vector<Id*> id_list;
	};  // 变量声明，全局变量和局部变量
	class ConstVarDec : public Unit {
	public:
		std::vector<Id*> id_list;
	};
	class FuncDef : public Unit {
	public:
		Type* type;
		std::string name;
		FuncFPs fps;
		Block block;
	};  // 函数定义，函数定义后面一般是Block
	class FuncFPs {
	public:
		std::vector<FuncDef*> fp_list;
	};
	class FuncFp {
	public:
		std::pair<Type*, Id*> fp;
	};
	class Block {
	public:
		std::vector <Stm*> stm_list;
	};  // 代码块
	class Stm {};  // Statement 语句
	class AssStm : public Stm {};  // 赋值语句
	class IfStm : public Stm {};  // IF语句，后面可有else语句
	class ElseStm : public Stm {};  // Else语句
	class WhileStm : public Stm {};
	class ContinueStm : public Stm {};
	class BreakStm : public Stm {};
	class ReturnStm : public Stm {};

	class Type {};
	class IntType : public Type {};
	class VoidType : public Type {};
	class FloatType : public Type {};

	class Val {};  // 值类型
	class IntVal : public Val {
	public:
		int val;
	};  // int值类型
	class FloatVal : public Val {
	public:
		float val;
	};  // float值类型

	class Id {
	public:
		std::string name;
	};
	
    //表达式部分
    class Expression{
        int exp;
    }
    //条件表达式
    class ConditionExp: public Expression{
    	public:  
	        int operator;
	        Expression& lcond;
	        Expression& rcond;
    }
    //数值
    class Number: public Expression{
        public:
            int numbervalue;
    }
    //左值表达式
    class LeftValueExp: public Expression{

    }

    //函数实参
    class FunctionActualParams;
    //函数调用表达式 函数名+实参列表（不需要返回值）
    class FunctionCallExp: public Expression{
        public:
            Id& functionName;
            FunctionActualParams& arugments;
    }

    //一元表达式
    class UnaryExpression: public Expression{
        public:
            int operator;
            Expression& rcond;
            
    }
    //二进制表达式
    class BinaryEXpression: public Expression{
        public: 
            int operator;
            Expression& lcond;
            Expression& rcond;
    }
    // 
}

#endif
