#ifndef AST_HPP
#define AST_HPP

#include <vector>

#include "cmn.hpp"

namespace AST {
	class Root {
	public:
		std::vector <Unit*> unit_list;
	};  // AST�ĸ����
	class Unit {
	public:
		u32 line;
		u32 column;
	};  // AST��ÿ�����뵥Ԫ������һ��ȫ�ֱ����������������Ķ��壨sysY����ʵ�ֺ�����������
	class VarDec : public Unit {
		std::vector<Id*> id_list;
	};  // ����������ȫ�ֱ����;ֲ�����
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
	};  // �������壬�����������һ����Block
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
	};  // �����
	class Stm {};  // Statement ���
	class AssStm : public Stm {};  // ��ֵ���
	class IfStm : public Stm {};  // IF��䣬�������else���
	class ElseStm : public Stm {};  // Else���
	class WhileStm : public Stm {};
	class ContinueStm : public Stm {};
	class BreakStm : public Stm {};
	class ReturnStm : public Stm {};

	class Type {};
	class IntType : public Type {};
	class VoidType : public Type {};
	class FloatType : public Type {};

	class Val {};  // ֵ����
	class IntVal : public Val {
	public:
		int val;
	};  // intֵ����
	class FloatVal : public Val {
	public:
		float val;
	};  // floatֵ����

	class Id {
	public:
		std::string name;
	};
	
    //���ʽ����
    class Expression{
        int exp;
    }
    //�������ʽ
    class ConditionExp: public Expression{
    	public:  
	        int operator;
	        Expression& lcond;
	        Expression& rcond;
    }
    //��ֵ
    class Number: public Expression{
        public:
            int numbervalue;
    }
    //��ֵ���ʽ
    class LeftValueExp: public Expression{

    }

    //����ʵ��
    class FunctionActualParams;
    //�������ñ��ʽ ������+ʵ���б�����Ҫ����ֵ��
    class FunctionCallExp: public Expression{
        public:
            Id& functionName;
            FunctionActualParams& arugments;
    }

    //һԪ���ʽ
    class UnaryExpression: public Expression{
        public:
            int operator;
            Expression& rcond;
            
    }
    //�����Ʊ��ʽ
    class BinaryEXpression: public Expression{
        public: 
            int operator;
            Expression& lcond;
            Expression& rcond;
    }
    // 
}

#endif
