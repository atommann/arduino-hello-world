/*
 * A tool used to calculate the delay time for AVR assembler.
 *
 * Atommann
 * Oct. 2, 2017
 *
 */

#include <stdio.h>
#include <stdint.h>

#define F_CPU 16000000UL

int sum1(int x)
{
    int i;
    int sum = 0;

    for (i = 1; i <= x; i++)
    {
        sum += (7*i - 1);
    }

    return sum;
}

int sum2(int x)
{
    int i, j;
    int sum = 0;
    int sum_inner = 0;

    for (i = 1; i <= x; i++)
    {
        sum_inner = 0;
        for (j = 1; j <= i; j++)
        {
            sum_inner += (3*j - 1);
        }
        
        sum += sum_inner;
    }

    return sum;
}


int main(void)
{
    int i, j;
    int x;
    int T;
    float tick;
    float delay_time;

    tick = 1000*1000*1.0/F_CPU;

    printf("; 通用延时子程序控制常数与延时周期和时间\n");
    printf("; 《AVR 单片机嵌入式系统原理与应用实践》Page 113\n");
    printf("; 计算方法:\n");

    printf(";                     x                   x    i                   \n");
    printf(";                   _____               ____  ____                 \n");
    printf(";                   \\    /       \\      \\     \\    /       \\  \n");
    printf("; T = 11 + 7x -1 +  /___ | 7i - 1 |  +  /___  /___ | 3j - 1 |      \n");
    printf(";                    i=1 \\       /       i=1  j=1  \\       /     \n");
    printf(";\n");

    printf("; F_CPU = %d Hz\n", F_CPU);
    printf("; 机器周期 t = %f us\n", tick);
    printf("; 时间单位: us\n");

    printf(";");

    printf("%3s  %7s  %12s  ", "x", "T", "Delay_Time");
    printf("%3s  %7s  %12s  ", "x", "T", "Delay_Time");
    printf("%3s  %7s  %12s  ", "x", "T", "Delay_Time");
    printf("%3s  %7s  %12s  ", "x", "T", "Delay_Time");

    printf("\n");

    printf("; ");
    for(i = 0; i < 109; i++)
        printf("-");

    printf("\n");


    for (i = 1; i <= 64; i++)
    {
        printf(";");
        for (j = 0; j < 4; j++)
        {
            x = i + 64*j;

            T = 11 + 7*x  - 1 + sum1(x) + sum2(x);
            delay_time = tick * T;
            printf("%3d  %7d  %12.4f  ", x, T, delay_time);
        }
        printf("\n");

    }

    return 0;
}

