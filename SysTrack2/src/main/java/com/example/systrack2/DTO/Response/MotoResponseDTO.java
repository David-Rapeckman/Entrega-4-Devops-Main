package com.example.systrack2.DTO.Response;

import com.example.systrack2.domain.enums.Status;
import lombok.Data;

@Data
public class MotoResponseDTO {
    private Long id;
    private String placa;
    private String modelo;
    private int ano;
    private double quilometragem;
    private Status status;
    private Long usuarioId;
    private String nomeUsuario;
    private Long patioId;
    private String nomePatio;
}