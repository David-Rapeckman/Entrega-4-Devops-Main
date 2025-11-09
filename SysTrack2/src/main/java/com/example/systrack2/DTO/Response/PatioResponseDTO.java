package com.example.systrack2.DTO.Response;

import lombok.Data;

@Data
public class PatioResponseDTO {
    private Long id;
    private String nome;
    private String endereco;
    private int qtdMotos;
}