package com.example.systrack2.DTO.Request;

import lombok.Data;

@Data
public class UsuarioRequestDTO {
    private String nome;
    private String email;
    private String senha;
    private String role; // "ADMIN" ou "USER"
}
